//
//  DemoAttributedStringViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoAttributedStringViewController
class DemoAttributedStringViewController: TableViewController {
    private lazy var attributedLabel = Components.label.default()
        .with(attributedText: self.attributedLabelString)
        .with(paddingEdgeInset: UIEdgeInsets(16))
    private lazy var clickableAttributedLabel = Components.label.default()
        .with(attributedText: self.clickableAttributedLabelString)
        .with(backgroundColor: UIColor.lightGray)
        .with(paddingEdgeInset: UIEdgeInsets(16))
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private lazy var attributedLabelString = AttributedString()
        .with(color: UIColor.label)
        .with(font: UIFont.systemFont(ofSize: 14))
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
        .with(color: UIColor.label)
        .with(font: UIFont.systemFont(ofSize: 16))
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
        .with(font: UIFont.boldSystemFont(ofSize: 23))
        .with(underlineStyle: .thick)
        .with(string: "Tapable item", onClick: { print("Click") })
        .with(string: "\nSome text")
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.attributedLabel,
            self.clickableAttributedLabel
        ], divider: self.divider)
    }
}
