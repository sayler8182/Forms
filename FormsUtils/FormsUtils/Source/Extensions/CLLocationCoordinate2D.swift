//
//  CLLocationCoordinate2D.swift
//  FormsUtils
//
//  Created by Konrad on 10/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreLocation
import Foundation

// MARK: CLLocationCoordinate2D
public extension CLLocationCoordinate2D {
    init?(latitude: String?,
          longitude: String?) {
        guard let latitude: Double = latitude?.asDouble else { return nil }
        guard let longitude: Double = longitude?.asDouble else { return nil }
        self.init(
            latitude: latitude,
            longitude: longitude)
    }
    
    func distance(from: CLLocationCoordinate2D) -> Double {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return to.distance(from: from)
    }
    
    func range(latDelta: CLLocationDegrees,
               lngDelta: CLLocationDegrees) -> Double {
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: self.latitude + latDelta,
            longitude: self.longitude + lngDelta)
        return self.distance(from: coordinate)
    }
}
