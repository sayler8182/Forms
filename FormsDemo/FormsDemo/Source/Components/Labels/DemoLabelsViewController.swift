//
//  DemoLabelsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoLabelsViewController
class DemoLabelsViewController: FormsTableViewController {
    private let shortLabel = Components.label.default()
        .with(backgroundColor: Theme.Colors.red)
        .with(text: "Some short text")
    private let longLabel = Components.label.default()
        .with(backgroundColor: Theme.Colors.green)
        .with(componentColor: Theme.Colors.gray)
        .with(margin: 16)
        .with(numberOfLines: 5)
        .with(text: LoremIpsum.paragraph(sentences: 5))
    private let veryLongLabel = Components.label.default()
        .with(alignment: .notNatural)
        .with(backgroundColor: Theme.Colors.blue)
        .with(color: Theme.Colors.white)
        .with(numberOfLines: 0)
        .with(margin: 16)
        .with(text: LoremIpsum.paragraph(sentences: 15))
    private let clickableLabel = Components.label.default()
        .with(alignment: .center)
        .with(font: Theme.Fonts.bold(ofSize: 24))
        .with(isUserInteractionEnabled: true)
        .with(text: "Tap me")
     
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.shortLabel,
            self.longLabel,
            self.veryLongLabel,
            self.clickableLabel
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.clickableLabel.onClick = Unowned(self) { (_self) in
            UIAlertController(preferredStyle: .alert)
                .with(title: "Tapped")
                .with(message: "Clickable label")
                .with(action: "Ok")
                .with(action: "Cancel", style: .destructive)
                .present(on: _self)
        }
    }
}
