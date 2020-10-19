//
//  MapAppleClusterManager.swift
//  FormsMapKit
//
//  Created by Konrad on 10/26/20.
//

import CoreLocation
import FormsUtils
import MapKit

// MARK: MapAppleClusterManagerDelegate
public protocol MapAppleClusterManagerDelegate: class {
    func cellSize(for zoomLevel: Double) -> Double?
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool
}

public extension MapAppleClusterManagerDelegate {
    func cellSize(for zoomLevel: Double) -> Double? {
        return nil
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return true
    }
}

// MARK: MapAppleClusterManager
public extension MapAppleClusterManager {
    enum ClusterPosition {
        case center
        case nearCenter
        case average
        case first
    }
}

// MARK: MapAppleClusterManager
open class MapAppleClusterManager {
    var tree: QuadTree = QuadTree(rect: .world)
    let operationQueue = OperationQueue.serial
    let dispatchQueue = DispatchQueue(label: "com.cluster.concurrentQueue", attributes: .concurrent)
    
    open internal(set) var zoomLevel: Double = 0
    open var maxZoomLevel: Double = 20
    open var minCountForClustering: Int = 3
    open var shouldRemoveInvisibleAnnotations: Bool = true
    open var shouldDistributeAnnotationsOnSameCoordinate: Bool = true
    open var visibleAnnotations: [MKAnnotation] = []
    open var clusterPosition: ClusterPosition = .average
    open weak var delegate: MapAppleClusterManagerDelegate?
    
    open var annotations: [MKAnnotation] {
        return self.dispatchQueue.sync {
            self.tree.annotations(in: .world)
        }
    }
    open var visibleNestedAnnotations: [MKAnnotation] {
        return self.dispatchQueue.sync {
            return self.visibleAnnotations
                .compactMap { $0 as? MapAppleCluster }
                .map { $0.annotations }
                .reduce(into: [], { $0 += $1 })
        }
    }
    
    public init() {}

    open func add(_ annotation: MKAnnotation) {
        self.operationQueue.cancelAllOperations()
        self.dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree.add(annotation)
        }
    }
    
    open func add(_ annotations: [MKAnnotation]) {
        self.operationQueue.cancelAllOperations()
        self.dispatchQueue.async(flags: .barrier) { [weak self] in
            for annotation in annotations {
                self?.tree.add(annotation)
            }
        }
    }
    
    open func remove(_ annotation: MKAnnotation) {
        self.operationQueue.cancelAllOperations()
        self.dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree.remove(annotation)
        }
    }
    
    open func remove(_ annotations: [MKAnnotation]) {
        self.operationQueue.cancelAllOperations()
        self.dispatchQueue.async(flags: .barrier) { [weak self] in
            for annotation in annotations {
                self?.tree.remove(annotation)
            }
        }
    }
    
    open func removeAll() {
        self.operationQueue.cancelAllOperations()
        self.dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree = QuadTree(rect: .world)
        }
    }
    
    open func reload(mapView: MKMapView,
                     animated: Bool = true,
                     completion: ((Bool) -> Void)? = nil) {
        let mapBounds: CGRect = mapView.bounds
        let visibleMapRect: MKMapRect = mapView.visibleMapRect
        let visibleMapRectWidth: Double = visibleMapRect.size.width
        let zoomScale: Double = Double(mapBounds.width) / visibleMapRectWidth
        self.operationQueue.cancelAllOperations()
        self.operationQueue.addBlockOperation { [weak self, weak mapView] (operation) in
            guard let `self` = self else { completion?(false); return; }
            guard let mapView: MKMapView = mapView else { completion?(false); return; }
            autoreleasepool {
                let (toAdd, toRemove) = self.clusteredAnnotations(zoomScale: zoomScale, visibleMapRect: visibleMapRect, operation: operation)
                DispatchQueue.main.async {
                    self.display(
                        mapView: mapView,
                        toAdd: toAdd,
                        toRemove: toRemove,
                        animated: animated,
                        completion: completion)
                }
            }
        }
    }
    
    open func clusteredAnnotations(zoomScale: Double,
                                   visibleMapRect: MKMapRect,
                                   operation: Operation? = nil) -> (toAdd: [MKAnnotation], toRemove: [MKAnnotation]) {
        var isCancelled: Bool { return operation?.isCancelled ?? false }
        guard !isCancelled else { return (toAdd: [], toRemove: []) }
        let mapRects = self.mapRects(zoomScale: zoomScale, visibleMapRect: visibleMapRect)
        guard !isCancelled else { return (toAdd: [], toRemove: []) }
        if self.shouldDistributeAnnotationsOnSameCoordinate {
            self.distributeAnnotations(tree: tree, mapRect: visibleMapRect)
        }
        let allAnnotations: [MKAnnotation] = self.dispatchQueue.sync {
            self.clusteredAnnotations(tree: tree, mapRects: mapRects, zoomLevel: zoomLevel)
        }
        guard !isCancelled else { return (toAdd: [], toRemove: []) }
        let before: [MKAnnotation] = self.visibleAnnotations
        let after: [MKAnnotation] = allAnnotations
        var toRemove: [MKAnnotation] = before.subtracted(after)
        let toAdd: [MKAnnotation] = after.subtracted(before)
        if !self.shouldRemoveInvisibleAnnotations {
            let toKeep: [MKAnnotation] = toRemove.filter { !visibleMapRect.contains($0.coordinate) }
            toRemove.subtract(toKeep)
        }
        self.dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.visibleAnnotations.subtract(toRemove)
            self?.visibleAnnotations.add(toAdd)
        }
        return (toAdd: toAdd, toRemove: toRemove)
    }
    
    func clusteredAnnotations(tree: QuadTree,
                              mapRects: [MKMapRect],
                              zoomLevel: Double) -> [MKAnnotation] {
        var allAnnotations: [MKAnnotation] = []
        for mapRect in mapRects {
            var annotations: [MKAnnotation] = []
            for node in tree.annotations(in: mapRect) {
                if self.delegate?.shouldClusterAnnotation(node) ?? true {
                    annotations.append(node)
                } else {
                    allAnnotations.append(node)
                }
            }
            
            let count: Int = annotations.count
            if count >= self.minCountForClustering, zoomLevel <= self.maxZoomLevel {
                let cluster: MapAppleCluster = MapAppleCluster()
                cluster.coordinate = self.coordinate(
                    annotations: annotations,
                    position: self.clusterPosition,
                    mapRect: mapRect)! //swiftlint:disable:this force_unwrapping
                cluster.annotations = annotations
                allAnnotations += [cluster]
            } else {
                allAnnotations += annotations
            }
        }
        return allAnnotations
    }
    
    func distributeAnnotations(tree: QuadTree, mapRect: MKMapRect) {
        let annotations = dispatchQueue.sync {
            tree.annotations(in: mapRect)
        }
        let hash = Dictionary(grouping: annotations) { $0.coordinate }
        self.dispatchQueue.async(flags: .barrier) {
            for value in hash.values where value.count > 1 {
                for (index, annotation) in value.enumerated() {
                    tree.remove(annotation)
                    let distanceFromContestedLocation: Double = 3 * Double(value.count) / 2
                    let radiansBetweenAnnotations: Double = (.pi * 2) / Double(value.count)
                    let bearing: Double = radiansBetweenAnnotations * Double(index)
                    let pointAnnotation = annotation as? MKPointAnnotation
                    pointAnnotation?.coordinate = annotation.coordinate.coordinate(
                        onBearingInRadians: bearing,
                        atDistanceInMeters: distanceFromContestedLocation)
                    tree.add(annotation)
                }
            }
        }
    }
    
    func coordinate(annotations: [MKAnnotation],
                    position: ClusterPosition,
                    mapRect: MKMapRect) -> CLLocationCoordinate2D? {
        switch position {
        case .center:
            return MKMapPoint(x: mapRect.midX, y: mapRect.midY).coordinate
        case .nearCenter:
            let coordinate = MKMapPoint(x: mapRect.midX, y: mapRect.midY).coordinate
            let annotation = annotations.min { coordinate.distance(from: $0.coordinate) < coordinate.distance(from: $1.coordinate) }
            return annotation?.coordinate
        case .average:
            let coordinates = annotations.map { $0.coordinate }
            let totals = coordinates.reduce((latitude: 0.0, longitude: 0.0)) { ($0.latitude + $1.latitude, $0.longitude + $1.longitude) }
            return CLLocationCoordinate2D(
                latitude: totals.latitude / Double(coordinates.count),
                longitude: totals.longitude / Double(coordinates.count))
        case .first:
            return annotations.first?.coordinate
        }
    }
    
    func mapRects(zoomScale: Double, visibleMapRect: MKMapRect) -> [MKMapRect] {
        guard !zoomScale.isInfinite, !zoomScale.isNaN else { return [] }
        
        zoomLevel = zoomScale.zoomLevel
        let scaleFactor = zoomScale / cellSize(for: zoomLevel)
        
        let minX = Int(floor(visibleMapRect.minX * scaleFactor))
        let maxX = Int(floor(visibleMapRect.maxX * scaleFactor))
        let minY = Int(floor(visibleMapRect.minY * scaleFactor))
        let maxY = Int(floor(visibleMapRect.maxY * scaleFactor))
        
        var mapRects = [MKMapRect]()
        for x in minX...maxX {
            for y in minY...maxY {
                var mapRect = MKMapRect(x: Double(x) / scaleFactor, y: Double(y) / scaleFactor, width: 1 / scaleFactor, height: 1 / scaleFactor)
                if mapRect.origin.x > MKMapPoint.max.x {
                    mapRect.origin.x -= MKMapPoint.max.x
                }
                mapRects.append(mapRect)
            }
        }
        return mapRects
    }
    
    open func display(mapView: MKMapView,
                      toAdd: [MKAnnotation],
                      toRemove: [MKAnnotation],
                      animated: Bool = true,
                      completion: ((Bool) -> Void)? = nil) {
        mapView.animation(
            animated,
            duration: 0.3,
            animations: {
                mapView.removeAnnotations(toRemove)
                mapView.addAnnotations(toAdd)
            },
            completion: completion)
    }
    
    func cellSize(for zoomLevel: Double) -> Double {
        if let cellSize = self.delegate?.cellSize(for: zoomLevel) { return cellSize }
        switch zoomLevel {
        case 13...15: return 64
        case 16...18: return 32
        case 19...: return 16
        default: return 88
        }
    }
}
