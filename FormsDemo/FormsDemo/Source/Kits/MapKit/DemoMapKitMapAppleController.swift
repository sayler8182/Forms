//
//  DemoMapKitMapAppleController.swift
//  FormsDemo
//
//  Created by Konrad on 10/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsMapKit
import FormsToastKit
import FormsUtils
import UIKit

// MARK: DemoMapKitMapAppleController
class DemoMapKitMapAppleController: FormsTableViewController {
    private let mapView = Components.map.apple()
        .with(height: 350)
        .with(showsUserLocation: true)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.setRegion(lat: 50.025, lng: 21.999, distance: 2_000)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.mapView
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
    }
}
