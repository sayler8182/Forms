//
//  DemoLabelsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoLabelsViewController
class DemoLabelsViewController: TableViewController {
    private let shortLabel = Components.label.label()
        .with(backgroundColor: UIColor.red)
        .with(text: "Some short text")
    private let longLabel = Components.label.label()
        .with(backgroundColor: UIColor.green)
        .with(componentColor: UIColor.lightGray)
        .with(edgeInset: UIEdgeInsets(16))
        .with(numberOfLines: 5)
        .with(text: LoremIpsum.paragraph(sentences: 5))
    private let veryLongLabel = Components.label.label()
        .with(alignment: .notNatural)
        .with(backgroundColor: UIColor.blue)
        .with(color: UIColor.white)
        .with(paddingEdgeInset: UIEdgeInsets(16))
        .with(text: LoremIpsum.paragraph(sentences: 15))
    private let clickableLabel = Components.label.label()
        .with(alignment: .center)
        .with(font: UIFont.boldSystemFont(ofSize: 24))
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
        self.clickableLabel.onClick = { [unowned self] in
            UIAlertController()
                .with(title: "Tapped")
                .with(message: "Clickable label")
                .with(action: "Ok")
                .with(action: "Cancel", style: .destructive)
                .present(on: self)
        }
    }
}
