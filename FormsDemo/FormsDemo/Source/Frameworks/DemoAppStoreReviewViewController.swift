//
//  DemoAppStoreReviewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAppStoreReview
import FormsInjector
import FormsUtils
import UIKit

// MARK: DemoAppStoreReviewViewController
class DemoAppStoreReviewViewController: FormsTableViewController {
    private let updateLaunchButton = Components.button.default()
        .with(title: "Update launch")
    
    @Injected
    private var appStoreReview: AppStoreReviewProtocol // swiftlint:disable:this let_var_whitespace
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func postInit() {
        super.postInit()
        self.appStoreReview.initFirstLaunchIfNeeded()
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.updateLaunchButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.updateLaunchButton.onClick = Unowned(self) { (_self) in
            _self.appStoreReview.launch()
            _self.appStoreReview.showIfNeeded()
        }
    }
}
