//
//  DemoDeveloperToolsConsoleViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/12/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import DeveloperTools
import Forms
import UIKit

// MARK: DemoDeveloperToolsConsoleViewController
class DemoDeveloperToolsConsoleViewController: FormsViewController {
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(numberOfLines: 0)
        .with(text: "Make sure that OS_ACTIVITY_MODE is enabled to see logs")
    private let incorrerctButton = Components.button.default()
        .with(title: "Incorrerct constraints")
    private let incorrerctLabel = Components.label.default()
        .with(text: "Incorrerct constraints")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.titleLabel, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal
        ])
        self.view.addSubview(self.incorrerctButton, with: [
            Anchor.to(self.titleLabel).topToBottom.offset(10),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.incorrerctButton).height(60),
            Anchor.to(self.incorrerctButton).height(50),
            Anchor.to(self.incorrerctButton).height(20)
        ])
        self.view.addSubview(self.incorrerctLabel, with: [
            Anchor.to(self.incorrerctButton).topToBottom.offset(10),
            Anchor.to(self.view).leading,
            Anchor.to(self.view).trailing,
            Anchor.to(self.incorrerctLabel).width
        ])
    }
}
