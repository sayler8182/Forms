//
//  DemoTitleTextFieldViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoTitleTextFieldViewController
class DemoTitleTextFieldViewController: TableViewController {
    private let textField = Components.input.titleTextField()
        .with(placeholder: "Text")
        .with(title: "Input")
    private let disableTextField = Components.input.titleTextField()
        .with(placeholder: "Text")
        .with(isEnabled: false)
        .with(title: "Disable")
    private let amountTextField = Components.input.titleAmountTextField()
        .with(title: "Amount")
    private let errorTextField = Components.input.titleTextField()
        .with(error: LoremIpsum.paragraph(sentences: 3))
        .with(placeholder: "Some text")
        .with(title: "Error")
    private let longErrorTextField = Components.input.titleTextField()
        .with(error: LoremIpsum.paragraph(sentences: 3))
        .with(placeholder: "Some text")
        .with(title: "Long error")
    private let infoTextField = Components.input.titleTextField()
        .with(info: LoremIpsum.paragraph(sentences: 2))
        .with(placeholder: "Some text")
        .with(title: "Info")
        .with(titleColor: UIColor.blue)
    private let infoAndErrorTextField = Components.input.titleTextField()
        .with(error: LoremIpsum.paragraph(sentences: 2))
        .with(info: LoremIpsum.paragraph(sentences: 2))
        .with(placeholder: "Some text")
        .with(title: "Info and error")
    private let footerTextField = Components.input.titleTextField()
        .with(text: "Some text")
        .with(title: "Footer")
    
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
            self.infoAndErrorTextField
        ], divider: self.divider)
    }
    
    override func setupFooter() {
        super.setupFooter()
        self.addToFooter([
            self.footerTextField
        ])
    }
}
