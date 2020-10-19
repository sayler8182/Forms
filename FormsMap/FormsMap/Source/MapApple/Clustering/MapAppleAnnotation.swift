//
//  MapAppleAnnotation.swift
//  FormsMapKit
//
//  Created by Konrad on 10/26/20.
//

import MapKit

// MARK: MapAppleClusterAnnotation
open class MapAppleCluster: MKPointAnnotation {
    open var annotations: [MKAnnotation] = []
    
    override open func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? MapAppleCluster else { return false }
        if self === object { return true }
        if self.coordinate != object.coordinate { return false }
        if self.annotations.count != object.annotations.count { return false }
        return self.annotations.map { $0.coordinate } == object.annotations.map { $0.coordinate }
    }
}
