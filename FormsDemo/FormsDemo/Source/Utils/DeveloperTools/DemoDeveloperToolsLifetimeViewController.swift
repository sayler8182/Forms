//
//  DemoDeveloperToolsLifetimeViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//
#if canImport(DeveloperTools)

import DeveloperTools
import Forms
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
        self.createLeaksButton.onClick = { [unowned self] in
            self.createLeaks()
        }
        self.removeLeaksButton.onClick = { [unowned self] in
            self.removeLeaks()
        }
    }
    
    private func createLeaks() {
        Self.leakStorage.append(Demo1Item())
        Self.leakStorage.append(Demo1Item())
        Self.leakStorage.append(Demo2Item())
        Self.leakStorage.append(Demo3Item())
        Self.leakStorage.append(Demo1Item2())
        Self.leakStorage.append(Demo1Item2())
        Self.leakStorage.append(Demo2Item2())
        Self.leakStorage.append(Demo3Item2())
    }

    private func removeLeaks() {
        Self.leakStorage.removeAll()
    }
}

// MARK: DemoItem
private class DemoItem: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 3, groupType: Self.self, groupMaxCount: 3)
    }

    init() {
        self.lifetimeTrack()
    }
}
private class Demo1Item: DemoItem { }
private class Demo2Item: DemoItem { }
private class Demo3Item: DemoItem {
    override class var lifetimeConfiguration: LifetimeConfiguration {
        return super.lifetimeConfiguration.with(maxCount: 1)
    }
}

// MARK: DemoItem2
private class DemoItem2: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 3, groupType: Self.self, groupMaxCount: 3)
    }

    init() {
        self.lifetimeTrack()
    }
}
private class Demo1Item2: DemoItem2 { }
private class Demo2Item2: DemoItem2 { }
private class Demo3Item2: DemoItem2 {
    override class var lifetimeConfiguration: LifetimeConfiguration {
        return super.lifetimeConfiguration.with(maxCount: 1)
    }
}

#endif
