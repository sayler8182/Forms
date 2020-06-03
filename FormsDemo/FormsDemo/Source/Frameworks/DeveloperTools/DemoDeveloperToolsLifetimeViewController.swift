//
//  DemoDeveloperToolsLifetimeViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsDeveloperTools
import UIKit

// MARK: DemoDeveloperToolsLifetimeViewController
class DemoDeveloperToolsLifetimeViewController: FormsTableViewController {
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
        self.createLeaksButton.onClick = Unowned(self) { (_self) in
            _self.createLeaks()
        }
        self.removeLeaksButton.onClick = Unowned(self) { (_self) in
            _self.removeLeaks()
        }
    }
    
    private func createLeaks() {
        Self.leakStorage.append(Leak1Item())
        Self.leakStorage.append(Leak1Item())
        Self.leakStorage.append(Leak2Item())
        Self.leakStorage.append(Leak3Item())
        Self.leakStorage.append(Leak1Item2())
        Self.leakStorage.append(Leak1Item2())
        Self.leakStorage.append(Leak2Item2())
        Self.leakStorage.append(Leak3Item2())
    }

    private func removeLeaks() {
        Self.leakStorage.removeAll()
    }
}

// MARK: LeakItem
private class LeakItem: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 3, groupType: Self.self, groupMaxCount: 3)
    }

    init() {
        self.lifetimeTrack()
    }
}
private class Leak1Item: LeakItem { }
private class Leak2Item: LeakItem { }
private class Leak3Item: LeakItem {
    override class var lifetimeConfiguration: LifetimeConfiguration {
        return super.lifetimeConfiguration.with(maxCount: 1)
    }
}

// MARK: LeakItem2
private class LeakItem2: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 3, groupType: Self.self, groupMaxCount: 3)
    }

    init() {
        self.lifetimeTrack()
    }
}
private class Leak1Item2: LeakItem2 { }
private class Leak2Item2: LeakItem2 { }
private class Leak3Item2: LeakItem2 {
    override class var lifetimeConfiguration: LifetimeConfiguration {
        return super.lifetimeConfiguration.with(maxCount: 1)
    }
}
