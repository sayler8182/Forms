//
//  FormsIntegrationDeveloperToolsViewController.swift
//  FormsIntegration
//
//  Created by Konrad on 4/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import DeveloperTools
import Forms
import UIKit

// MARK: FormsIntegrationDeveloperToolsViewController
class FormsIntegrationDeveloperToolsViewController: FormsTableViewController {
    private let createLeaksButton = Components.button.default()
        .with(title: "Create leaks")
    private let removeLeaksButton = Components.button.default()
        .with(title: "Remove leaks")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    static let lifetimeConfiguration = LifetimeConfiguration(maxCount: 1)
    private static var leakStorage: [AnyObject] = []
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.createLeaksButton,
            self.removeLeaksButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.createLeaksButton.onClick = { [unowned self] in
            self.createLeaks()
        }
        self.removeLeaksButton.onClick = { [unowned self] in
            self.removeLeaks()
        }
    }
    
    private func createLeaks() {
        Self.leakStorage.append(LeakItem())
    }

    private func removeLeaks() {
        Self.leakStorage.removeAll()
    }
}

// MARK: LeakItem
private class LeakItem: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 0, groupType: Self.self)
    }

    init() {
        self.lifetimeTrack()
    }
}
