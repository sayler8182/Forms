//
//  DemoAppStoreReviewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import Forms
import UIKit

// MARK: DemoAppStoreReviewViewController
class DemoAppStoreReviewViewController: FormsViewController {
    private let updateLaunchButton = Components.button.default()
        .with(title: "Update launch")
    
    private let appStoreReview = AppStoreReview()
    
    override func postInit() {
        super.postInit()
        self.appStoreReview.initFirstLaunchIfNeeded()
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.updateLaunchButton, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        self.updateLaunchButton.onClick = { [unowned self] in
            self.appStoreReview.launch()
            self.appStoreReview.showIfNeeded()
        }
    }
}
