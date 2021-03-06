//
//  DemoTitleTextFieldViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoTitleTextFieldViewController
class DemoTitleTextFieldViewController: FormsTableViewController {
    private lazy var textField = Components.input.textField.default()
        .with(actionView: self.actionView)
        .with(placeholder: "Text")
        .with(title: "Input")
    private let disableTextField = Components.input.textField.default()
        .with(placeholder: "Text")
        .with(isEnabled: false)
        .with(title: "Disable")
    private let amountTextField = Components.input.textField.amount.default()
        .with(title: "Amount")
    private let errorTextField = Components.input.textField.default()
        .with(error: LoremIpsum.paragraph(sentences: 3))
        .with(placeholder: "Some text")
        .with(title: "Error")
    private let longErrorTextField = Components.input.textField.default()
        .with(error: LoremIpsum.paragraph(sentences: 3))
        .with(placeholder: "Some text")
        .with(title: "Long error")
    private let infoTextField = Components.input.textField.default()
        .with(info: LoremIpsum.paragraph(sentences: 2))
        .with(placeholder: "Some text")
        .with(title: "Info")
        .with(titleColor: Theme.Colors.blue)
    private let infoAndErrorTextField = Components.input.textField.default()
        .with(error: LoremIpsum.paragraph(sentences: 2))
        .with(info: LoremIpsum.paragraph(sentences: 2))
        .with(placeholder: "Some text")
        .with(title: "Info and error")
    private let passwordTextField = Components.input.textField.password.default()
        .with(text: "Some password")
    private let footerTextField = Components.input.textField.default()
        .with(isDynamic: false)
        .with(text: "Some text")
        .with(title: "Footer")
    
    private lazy var actionView: UIView = Components.image.default()
        .with(image: UIImage.from(name: "pencil.circle"))
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.textField,
            self.disableTextField,
            self.amountTextField,
            self.errorTextField,
            self.longErrorTextField,
            self.infoTextField,
            self.infoAndErrorTextField,
            self.passwordTextField
        ], divider: self.divider)
    }
    
    override func setupFooter() {
        super.setupFooter()
        self.addToFooter([
            self.footerTextField
        ])
    }
}
