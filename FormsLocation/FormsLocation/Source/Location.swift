//
//  Location.swift
//  FormsLocation
//
//  Created by Konrad on 6/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreLocation
import FormsInjector
import FormsLogger
import FormsPermissions

// MARK: LocationProtocol
public protocol LocationProtocol {
    var isStarted: Bool { get }
    var lastLocation: CLLocation? { get }
    var onStatusChanged: Location.OnStatusChanged? { get set }
    var onLocationChanged: Location.OnLocationChanged? { get set }
    var onLocationOnce: Location.OnLocationChanged? { get set }
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func locationOnce(_ completion: @escaping Location.OnLocationChanged)
}

// MARK: Location
public class Location: NSObject, LocationProtocol {
    public typealias OnLocationChanged = (CLLocation?) -> Void
    public typealias OnStatusChanged = (CLAuthorizationStatus) -> Void
    
    private let locationManger = CLLocationManager()
    public private (set) var isStarted: Bool = false
    fileprivate var isWaitingForStatus: Bool = false
    
    private static var _lastLocationTime: TimeInterval? = nil
    private static var _lastLocation: CLLocation? = nil {
        didSet { Self._lastLocationTime = Date().timeIntervalSince1970 }
    }
    public var lastLocation: CLLocation? {
        return Self._lastLocation
    }
    
    public var onStatusChanged: OnStatusChanged? = nil
    public var onLocationChanged: OnLocationChanged? = nil
    public var onLocationOnce: OnLocationChanged? = nil
    
    override public init() {
        super.init()
        self.locationManger.delegate = self
    }
    
    public func startUpdatingLocation() {
        guard !self.isStarted && !self.isWaitingForStatus else { return }
        self.isWaitingForStatus = true
        Permissions.location.askWhenInUse { [weak self] (status) in
            guard let `self` = self else { return }
            let isAuthorized: Bool = status.isAuthorized
            if isAuthorized {
                self.locationManger.startUpdatingLocation()
                self.isStarted = true
            }
            self.isWaitingForStatus = false
        }
    }
    
    public func stopUpdatingLocation() {
        guard self.isStarted else { return }
        self.locationManger.stopUpdatingLocation()
        self.isStarted = false
    }
}

// MARK: LocationOnce
public extension Location {
    func locationOnce(_ completion: @escaping OnLocationChanged) {
        if let lastLocationTime = Self._lastLocationTime,
            let lastLocation = Self._lastLocation,
            Date().timeIntervalSinceNow < lastLocationTime + 60.0 {
            completion(lastLocation)
            return
        }
        self.onLocationOnce = nil
        Permissions.location.askWhenInUse { [weak self] (status) in
            guard let `self` = self else { return }
            guard status.isAuthorized else {
                completion(nil)
                return
            }
            self.onLocationOnce = completion
            self.startUpdatingLocation()
        }
    }
    
    private func handleLocationOnce(_ location: CLLocation?) {
        guard let onLocationOnce = self.onLocationOnce else { return }
        guard let location: CLLocation = location else { return }
        self.onLocationOnce = nil
        if self.onLocationChanged == nil {
            self.locationManger.stopUpdatingLocation()
        }
        onLocationOnce(location)
    }
}

// MARK: LocationChanged
public extension Location {
    private func handleLocationChanged(_ location: CLLocation?) {
        guard let onLocationChanged = self.onLocationChanged else { return }
        guard let location: CLLocation = location else { return }
        onLocationChanged(location)
    }
}

// MARK: CLLocationManagerDelegate
extension Location: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations.last
        Self._lastLocation = location
        self.handleLocationOnce(location)
        self.handleLocationChanged(location)
        let logger: Logger? = Injector.main.resolveOrDefault("FormsLocation")
        let log: String = String(
            format: "[LOCATION]: (%@,%@)",
            location?.coordinate.latitude.description ?? "",
            location?.coordinate.longitude.description ?? "")
        logger?.log(LogType.info, log)
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.onStatusChanged?(status)
    }
}
