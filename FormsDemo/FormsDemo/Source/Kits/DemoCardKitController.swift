//
//  DemoCardKitController.swift
//  FormsDemo
//
//  Created by Konrad on 5/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsCardKit
import FormsUtils
import UIKit

// MARRK: DemoCardKitController
class DemoCardKitController: FormsTableViewController {
    private let progerssBar = Components.progress.progressBar()
        .with(progress: 0.0)
    private let openButton = Components.button.default()
        .with(title: "Open")
    private let closeButton = Components.button.default()
        .with(title: "Close")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
    private let overlayView = Components.container.view()
        .with(backgroundColor: Theme.Colors.tertiaryLight.with(alpha: 0.3))
    
    private lazy var demoCardController = CardController(self.demoCardContentController)
    private lazy var demoCardContentController = DemoFormsCardContentController()
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.progerssBar,
            self.openButton,
            self.closeButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.openButton.onClick = Unowned(self) { (_self) in
            _self.demoCardController.open()
        }
        self.closeButton.onClick = Unowned(self) { (_self) in
            _self.demoCardController.close()
        }
        self.demoCardController.onProgress = Unowned(self) { (_self, progress) in
            _self.progerssBar.setProgress(progress, animated: true)
        }
    }
    
    override func setupOther() {
        super.setupOther()
        self.demoCardController.add(to: self, overlay: self.overlayView)
    }
}

// MARK: DemoFormsCardContentController
private class DemoFormsCardContentController: FormsTableViewController {
    private let closeButton = Components.button.default()
        .with(title: "Close")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
    
    override func setTheme() {
        super.setTheme()
        self.view.backgroundColor = Theme.Colors.tertiaryLight
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.closeButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.closeButton.onClick = Unowned(self) { (_self) in
            _self.cardController?.close()
        }
    }
}
