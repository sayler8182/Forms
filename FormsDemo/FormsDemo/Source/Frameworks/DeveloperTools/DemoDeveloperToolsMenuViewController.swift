//
//  DemoDeveloperToolsMenuViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsDeveloperTools
import UIKit

// MARK: DemoDeveloperToolsMenuViewController
class DemoDeveloperToolsMenuViewController: FormsTableViewController {
    private let appVersionLabel = Components.label.default()
        .with(alignment: .center)
        .with(numberOfLines: 0)
        .with(marginEdgeInset: UIEdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
        .with(text: "AppVersion:\n\(DeveloperTools.appVersion.fullVersion)")
    private let appBuildDateLabel = Components.label.default()
        .with(alignment: .center)
        .with(numberOfLines: 0)
        .with(marginEdgeInset: UIEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        .with(text: "AppBuildDate:\n\(DeveloperTools.appVersion.buildDate)")
    private let showDeveloperMenuButton = Components.button.default()
        .with(title: "Show Developer Menu")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.appVersionLabel,
            self.appBuildDateLabel,
            self.showDeveloperMenuButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.showDeveloperMenuButton.onClick = {
            DeveloperTools.showMenu()
        }
    }
}

// MARK: DemoDeveloperToolsMenuFirstFeatureViewController
class DemoDeveloperToolsMenuFirstFeatureViewController: FormsTableViewController {
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "This is first feature")
        .with(margin: 16)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.titleLabel
        ])
    }
}

// MARK: DemoDeveloperToolsMenuSecondFeatureViewController
class DemoDeveloperToolsMenuSecondFeatureViewController: FormsTableViewController {
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "This is second feature")
        .with(margin: 16)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.titleLabel
        ])
    }
}
