//
//  DemoViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import UIKit

// MARK: DemoViewViewController
class DemoViewController: FormsViewController {
    private let centerView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
        .with(height: 44)
    private let bottomView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
        .with(height: 44)
    
    override func setupContent() {
        super.setupContent()
        self.setupCenterView()
        self.setupBottomView()
    }
    
    private func setupCenterView() {
        self.view.addSubview(self.centerView, with: [
            Anchor.to(self.view).center(300, 44)
        ])
    }
    
    private func setupBottomView() {
        self.view.addSubview(self.bottomView, with: [
            Anchor.to(self.centerView).topToBottom.offset(16),
            Anchor.to(self.centerView).horizontal,
            Anchor.to(self.centerView).height
        ])
    }
}
