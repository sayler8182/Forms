//
//  MapApple.swift
//  FormsMapKit
//
//  Created by Konrad on 10/26/20.
//

import Forms
import FormsAnchor
import FormsUtilsUI
import MapKit
import UIKit

// MARK: MapApple
open class MapApple: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let mapView = MKMapView()
    public weak var delegate: MKMapViewDelegate? {
        didSet { self.mapView.delegate = delegate }
    }
    
    open var annotations: [MKAnnotation] = [] {
        didSet { self.updateAnnotations() }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var centerCoordinate: CLLocationCoordinate2D {
        return self.mapView.centerCoordinate
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var isClusterEnabled: Bool = false {
        didSet { self.reloadData() }
    }
    open var isZoomEnabled: Bool {
        get { return self.mapView.isZoomEnabled }
        set { self.mapView.isZoomEnabled = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var showsUserLocation: Bool = false {
        didSet { self.mapView.showsUserLocation = self.showsUserLocation }
    }
    override open var tintColor: UIColor? {
        get { return self.mapView.tintColor }
        set { self.mapView.tintColor = newValue }
    }
    open var zoomLevel: Double {
        return self.mapView.zoomLevel
    }
    
    private let clusterManager = MapAppleClusterManager()
    
    override open func setupView() {
        self.setupCluster()
        self.setupBackgroundView()
        self.setupMapView()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    open func setupCluster() {
        self.clusterManager.maxZoomLevel = 20
        self.clusterManager.minCountForClustering = 3
        self.clusterManager.delegate = self
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupMapView() {
        self.mapView.frame = self.bounds
        self.backgroundView.addSubview(self.mapView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    open func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.mapView.frame = self.backgroundView.bounds.with(inset: edgeInset)
        self.mapView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.mapView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.mapView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.mapView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Annotations
public extension MapApple {
    @available(iOS 11.0, *)
    func register(_ items: [String: AnyClass]) -> Self {
        for item in items {
            self.mapView.register(item.value, forAnnotationViewWithReuseIdentifier: item.key)
        }
        return self
    }
    
    @available(iOS 11.0, *)
    func register(_ items: [AnyClass]) -> Self {
        for item in items {
            self.mapView.register(item, forAnnotationViewWithReuseIdentifier: "\(item)")
        }
        return self
    }
}

// MARK: Map
public extension MapApple {
    func setRegion(lat: Double?,
                   lng: Double?,
                   distance: CLLocationDistance = 2_000,
                   animated: Bool = true) {
        guard let lat: Double = lat else { return }
        guard let lng: Double = lng else { return }
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.setRegion(center: center, distance: distance, animated: animated)
    }
    
    func setRegion(center: CLLocationCoordinate2D?,
                   distance: CLLocationDistance = 2_000,
                   animated: Bool = true) {
        guard let center: CLLocationCoordinate2D = center else { return }
        let region: MKCoordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: distance, longitudinalMeters: distance)
        self.setRegion(region, animated: animated)
    }
    
    func setRegion(_ region: MKCoordinateRegion?,
                   animated: Bool = true) {
        guard let region: MKCoordinateRegion = region else { return }
        self.mapView.setRegion(region, animated: animated)
    }
}

// MARK: Annotations
extension MapApple {
    func reloadData() {
        self.clusterManager.reload(mapView: self.mapView)
    }
    
    func updateAnnotations() {
        self.clusterManager.removeAll()
        self.clusterManager.add(self.annotations)
        self.clusterManager.reload(mapView: self.mapView)
    }
}

// MARK: MapAppleClusterManagerDelegate
extension MapApple: MapAppleClusterManagerDelegate {
    public func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return self.isClusterEnabled
    }
}

// MARK: Builder
public extension MapApple {
    func with(annotations: [MapAppleCluster]) -> Self {
        self.annotations = annotations
        return self
    }
    func with(delegate: MKMapViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(isClusterEnabled: Bool) -> Self {
        self.isClusterEnabled = isClusterEnabled
        return self
    }
    func with(isZoomEnabled: Bool) -> Self {
        self.isZoomEnabled = isZoomEnabled
        return self
    }
    func with(showsUserLocation: Bool) -> Self {
        self.showsUserLocation = showsUserLocation
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
}
