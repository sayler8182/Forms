//
//  DemoDeviceViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/12/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsDevice
import UIKit

// MARK: DemoDeviceViewController
class DemoDeviceViewController: FormsTableViewController {
    private let deviceDescriptionLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
        .with(text: "Description: " + Device.current.description)
    private let deviceNameLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: "Name: " + Device.current.name.or(""))
    private let deviceSystemNameLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: "SystemName: " + Device.current.systemName.or(""))
    private let deviceSystemVersionLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: "SystemVersion: " + Device.current.systemVersion.or(""))
    private let deviceModelLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: "Model: " + Device.current.model.or(""))
    private let deviceLocalizedModelLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: "LocalizedModel: " + Device.current.localizedModel.or(""))
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.deviceDescriptionLabel,
            self.deviceNameLabel,
            self.deviceSystemNameLabel,
            self.deviceSystemVersionLabel,
            self.deviceModelLabel,
            self.deviceLocalizedModelLabel
        ], divider: self.divider)
    }
}
