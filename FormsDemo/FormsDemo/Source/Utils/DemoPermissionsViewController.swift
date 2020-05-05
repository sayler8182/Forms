//
//  DemoPermissionsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Permission
import UIKit

class DemoPermissionsViewController: FormsTableViewController {
    private let askAllButton = Components.button.default()
        .with(title: "Ask all")
    private let locationStatusLabel = Components.label.default()
        .with(paddingEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
        .with(text: "Location status: ")
    private let locationDefaultButton = Components.button.default()
        .with(title: "Location")
    private let locationWhenInUseButton = Components.button.default()
        .with(title: "Location WhenInUse")
    private let locationAlwaysButton = Components.button.default()
        .with(title: "Location Always")
    private let notificationsStatusLabel = Components.label.default()
        .with(paddingEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
        .with(text: " Notifications status: ")
    private let notificationsDefaultButton = Components.button.default()
        .with(title: "Notifications")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.askAllButton,
            self.locationStatusLabel,
            self.locationDefaultButton,
            self.locationWhenInUseButton,
            self.locationAlwaysButton,
            self.notificationsStatusLabel,
            self.notificationsDefaultButton
        ], divider: self.divider)
        self.updateStatuses()
    }
    
    override func setupActions() {
        super.setupActions()
        self.askAllButton.onClick = { [unowned self] in
            let permissions: [Permissionable] = [
                Permission.location,
                Permission.notifications
            ]
            Permission.ask(permissions) { [weak self] _ in
                guard let `self` = self else { return }
                self.updateStatuses()
            }
        }
        self.locationDefaultButton.onClick = { [unowned self] in
            Permission.location.ask { [weak self] _ in
                guard let `self` = self else { return }
                self.updateLocationStatus()
            }
        }
        self.locationWhenInUseButton.onClick = { [unowned self] in
            Permission.location.askWhenInUse { [weak self] _ in
                guard let `self` = self else { return }
                self.updateLocationStatus()
            }
        }
        self.locationAlwaysButton.onClick = { [unowned self] in
            Permission.location.askAlways { [weak self] _ in
                guard let `self` = self else { return }
                self.updateLocationStatus()
            }
        }
        self.notificationsDefaultButton.onClick = { [unowned self] in
            Permission.notifications.ask { [weak self] _ in
                guard let `self` = self else { return }
                self.updateNotificationsStatus()
            }
        }
    }
    
    private func updateStatuses() {
        self.updateLocationStatus()
        self.updateNotificationsStatus()
    }
    
    private func updateLocationStatus() {
        Permission.location.status { status in
            DispatchQueue.main.async {
                self.locationStatusLabel.text = "Location status: " + status.rawValue
            }
        }
    }
    
    private func updateNotificationsStatus() {
        Permission.notifications.status { status in
            DispatchQueue.main.async {
                self.notificationsStatusLabel.text = "Notifications status: " + status.rawValue
            }
        }
    }
}
