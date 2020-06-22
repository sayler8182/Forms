//
//  DemoGradientButtonViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import UIKit

// MARK: DemoGradientButtonViewController
class DemoGradientButtonViewController: FormsTableViewController {
    private let activeButton = Components.button.gradient()
        .with(title: "Tap me")
    private let inactiveButton = Components.button.gradient()
        .with(isEnabled: false)
        .with(title: "Can't tap me")
    private let longTitleButton = Components.button.gradient()
        .with(title: LoremIpsum.paragraph(sentences: 2))
    private let veryLongTitleButton = Components.button.gradient()
        .with(title: LoremIpsum.paragraph(sentences: 15))
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.activeButton,
            self.inactiveButton,
            self.longTitleButton,
            self.veryLongTitleButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.activeButton.onClick = Unowned(self) { (_self) in
            UIAlertController()
                .with(title: "Tapped")
                .with(message: "Active button")
                .with(action: "Ok")
                .with(action: "Cancel", style: .destructive)
                .present(on: _self)
        }
    }
}
