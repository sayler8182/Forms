//
//  FormsIntegrationPermissionViewController.swift
//  FormsIntegration
//
//  Created by Konrad on 5/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Permission
import UIKit

class FormsIntegrationPermissionViewController: FormsTableViewController {
    private let askAllButton = Components.button.default()
        .with(title: "Ask all")
    private let locationStatusLabel = Components.label.default()
        .with(paddingEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: "Location status: ")
    private let notificationsStatusLabel = Components.label.default()
        .with(paddingEdgeInset: UIEdgeInsets(vertical: 4, horizontal: 16))
        .with(text: " Notifications status: ")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.askAllButton,
            self.locationStatusLabel,
            self.notificationsStatusLabel
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
