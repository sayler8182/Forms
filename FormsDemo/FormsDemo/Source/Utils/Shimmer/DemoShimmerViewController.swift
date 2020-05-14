//
//  DemoShimmerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import Forms
import UIKit

// MARK: DemoShimmerViewController
class DemoShimmerViewController: FormsViewController {
    private let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .with(image: Theme.Colors.gray)
        .rounded()
    private let titleLabel = Components.label.default()
        .with(text: "Title label")
    private let subtitleLabel = Components.label.default()
        .with(text: "Subtitle label")
    
    override func setupContent() {
        super.setupContent()
        self.setupTitleView()
        self.startShimmering()
        Utils.delay(10.0, self) { $0.stopShimmering() }
    }
    
    private func setupTitleView() {
        self.view.addSubview(self.iconView, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
            Anchor.to(self.view).leading.offset(16),
            Anchor.to(self.iconView).size(self.iconView.bounds.size)
        ])
        self.view.addSubview(self.titleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.view).trailing.offset(16),
            Anchor.to(self.iconView).bottomToCenterY.offset(2)
        ])
        self.view.addSubview(self.subtitleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.view).trailing.offset(16),
            Anchor.to(self.iconView).topToCenterY.offset(2)
        ])
    } 
}
