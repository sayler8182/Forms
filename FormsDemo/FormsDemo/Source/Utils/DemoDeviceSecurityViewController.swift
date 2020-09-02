//
//  DemoDeviceSecurityViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsInjector
import FormsUtils
import UIKit

// MARK: DemoDeviceSecurityViewController
class DemoDeviceSecurityViewController: FormsTableViewController {
    private let statusLabel = Components.label.default()
        .with(alignment: .center)
        .with(padding: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @Injected
    private var deviceSecurity: DeviceSecurityProtocol // swiftlint:disable:this let_var_whitespace
    
    override func setupView() {
        super.setupView()
        self.checkDeviceSecurity()
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.statusLabel
        ], divider: self.divider)
    }
    
    private func checkDeviceSecurity() {
        self.statusLabel.text = self.deviceSecurity.isSecure
            ? "Device is secure"
            : "Device is NOT secure"
    }
}
