//
//  DemoLocationViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreLocation
import Forms
import FormsInjector
import FormsLocation
import FormsUtils
import UIKit

// MARK: DemoLocationViewController
class DemoLocationViewController: FormsTableViewController {
    private let locationOnceLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
        .with(text: "Location: ")
    private let locationOnceButton = Components.button.default()
        .with(title: "Location once")
    private let locationChangedLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
        .with(text: "Location: ")
    private let locationChangedStartButton = Components.button.default()
        .with(title: "Location changed start")
    private let locationChangedStopButton = Components.button.default()
        .with(title: "Location changed stop")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private var location: LocationProtocol = {
        let location: LocationProtocol? = Injector.main.resolve()
        return location ?? Location()
    }()
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.locationOnceLabel,
            self.locationOnceButton,
            self.locationChangedLabel,
            self.locationChangedStartButton,
            self.locationChangedStopButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.location.onLocationChanged = Unowned(self) { (_self, location) in
            _self.updateLocationChanged(location: location)
        }
        self.locationOnceButton.onClick = Unowned(self) { (_self: DemoLocationViewController) in
            _self.location.locationOnce { [weak _self] (location) in
                guard let _self = _self else { return }
                _self.updateLocationOnce(location: location)
            }
        }
        self.locationChangedStartButton.onClick = Unowned(self) { (_self) in
            _self.location.startUpdatingLocation()
        }
        self.locationChangedStopButton.onClick = Unowned(self) { (_self) in
            _self.location.stopUpdatingLocation()
        }
    }
    
    private func updateLocationOnce(location: CLLocation?) {
        DispatchQueue.main.async {
            if let location: CLLocation = location {
                self.locationOnceLabel.text = "Location: (\(location.coordinate.latitude), \(location.coordinate.longitude))"
            } else {
                self.locationOnceLabel.text = "Can't determinate location"
            }
        }
    }
    
    private func updateLocationChanged(location: CLLocation?) {
        DispatchQueue.main.async {
            if let location: CLLocation = location {
                self.locationChangedLabel.text = "Location: (\(location.coordinate.latitude), \(location.coordinate.longitude))"
            } else {
                self.locationChangedLabel.text = "Can't determinate location"
            }
        }
    }
}
