//
//  Extensions.swift
//  FormsMapKit
//
//  Created by Konrad on 10/26/20.
//

import FormsUtils
import Foundation
import MapKit

// MARK: MKMapView
public extension MKMapView {
    var zoomLevel: Double {
        return log2(360 * ((self.frame.size.width.asDouble / 256.0) / self.region.span.longitudeDelta)) + 1
    }
    
    func dequeue<T: MKAnnotationView>(_ identifier: String) -> T! {
        return self.dequeueReusableAnnotationView(withIdentifier: identifier) as? T
    }
    func dequeue<T: MKAnnotationView>(_ identifier: String,
                                      _ type: T.Type) -> T! {
        return self.dequeueReusableAnnotationView(withIdentifier: identifier) as? T
    }
    
    func dequeue<T: MKAnnotationView>(_ type: T.Type) -> T! {
        return self.dequeueReusableAnnotationView(withIdentifier: "\(type)") as? T
    }
}

// MARK: MKMapRect
extension MKMapRect {
    init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.init(x: minX, y: minY, width: abs(maxX - minX), height: abs(maxY - minY))
    }
    init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }
    
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return self.contains(MKMapPoint(coordinate))
    }
}

// MARK: MKMapPoint
public extension MKMapPoint {
    static var max: MKMapPoint {
        return MKMapPoint(CLLocationCoordinate2D.max)
    }
}

// MARK: CLLocationCoordinate2D:
extension CLLocationCoordinate2D: Hashable {
    public static var max: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 90, longitude: 180)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// MAK: Double
extension Double {
    static var radiusOfEarth: Double {
        return 6_372_797.6
    }
    
    var zoomLevel: Double {
        let maxZoomLevel = log2(MKMapSize.world.width / 256) // 20
        let zoomLevel = floor(log2(self) + 0.5) // negative
        return max(0, maxZoomLevel + zoomLevel) // max - current
    }
}

extension CLLocationCoordinate2D {
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func coordinate(onBearingInRadians bearing: Double, atDistanceInMeters distance: Double) -> CLLocationCoordinate2D {
        let distRadians = distance / Double.radiusOfEarth
        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
    
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return location.distance(from: coordinate.location)
    }
}

// MARK: Array
extension Array where Element: MKAnnotation {
    func subtracted(_ other: [Element]) -> [Element] {
        return filter { item in !other.contains { $0.isEqual(item) } }
    }
    mutating func subtract(_ other: [Element]) {
        self = self.subtracted(other)
    }
    mutating func add(_ other: [Element]) {
        self.append(contentsOf: other)
    }
    @discardableResult
    mutating func remove(_ item: Element) -> Element? {
        return firstIndex { $0.isEqual(item) }.map { remove(at: $0) }
    }
}

// MARK: MKPolyline
extension MKPolyline {
    convenience init(mapRect: MKMapRect) {
        let points = [
            MKMapPoint(x: mapRect.minX, y: mapRect.minY),
            MKMapPoint(x: mapRect.maxX, y: mapRect.minY),
            MKMapPoint(x: mapRect.maxX, y: mapRect.maxY),
            MKMapPoint(x: mapRect.minX, y: mapRect.maxY),
            MKMapPoint(x: mapRect.minX, y: mapRect.minY)
        ]
        self.init(points: points, count: points.count)
    }
}

// MARK: OperationQueue
extension OperationQueue {
    static var serial: OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }
    
    func addBlockOperation(_ block: @escaping (BlockOperation) -> Void) {
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak operation] in
            guard let operation = operation else { return }
            block(operation)
        }
        self.addOperation(operation)
    }
}
