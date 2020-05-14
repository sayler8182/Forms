//
//  DemoAttributedStringViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit
import Utils

// MARK: DemoAttributedStringViewController
class DemoAttributedStringViewController: FormsTableViewController {
    private lazy var attributedLabel = Components.label.default()
        .with(attributedText: self.attributedLabelString)
        .with(numberOfLines: 0)
        .with(padding: 16)
    private lazy var clickableAttributedLabel = Components.label.default()
        .with(attributedText: self.clickableAttributedLabelString)
        .with(backgroundColor: UIColor.lightGray)
        .with(numberOfLines: 0)
        .with(padding: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private lazy var attributedLabelString = AttributedString()
        .with(color: Theme.Colors.primaryText)
        .with(font: Theme.Fonts.regular(ofSize: 14))
        .with(string: "Attributed label\n")
        .switchStyle()
        .with(color: UIColor.lightGray)
        .with(underlineStyle: .single)
        .with(string: "Some NSAttributedString\n")
        .with(string: "Attributed label\n")
        .with(alignment: .center)
        .with(string: "Is centered\n")
        .with(string: "Is still centered\n")
    private lazy var clickableAttributedLabelString = AttributedString()
        .with(color: Theme.Colors.primaryText)
        .with(font: Theme.Fonts.regular(ofSize: 16))
        .with(string: "Attributed label\n")
        .switchStyle()
        .with(color: UIColor.lightGray)
        .with(underlineStyle: .single)
        .with(string: "Some NSAttributedString\n")
        .with(string: "Attributed label\n")
        .with(alignment: .center)
        .with(string: "Is centered\n")
        .with(string: "Is still centered\n")
        .with(string: "\n")
        .switchStyle()
        .with(color: UIColor.red)
        .with(font: Theme.Fonts.bold(ofSize: 23))
        .with(underlineStyle: .thick)
        .with(string: "Tapable item", onClick: { [unowned self] in
            Toast.success()
                .with(title: "Click")
                .show(in: self.navigationController)
        })
        .with(string: "\nSome text")
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.attributedLabel,
            self.clickableAttributedLabel
        ], divider: self.divider)
    }
}
