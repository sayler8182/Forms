//
//  DemoTitleTextViewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit
import Utils

// MARK: DemoTitleTextViewViewController
class DemoTitleTextViewViewController: FormsTableViewController {
    private let textView = Components.input.textView.default()
        .with(placeholder: "Text")
        .with(title: "Input")
    private let disableTextView = Components.input.textView.default()
        .with(placeholder: "Text")
        .with(isEnabled: false)
        .with(title: "Disable")
    private let errorTextView = Components.input.textView.default()
        .with(error: LoremIpsum.paragraph(sentences: 3))
        .with(placeholder: "Some text")
        .with(title: "Error")
    private let longErrorTextView = Components.input.textView.default()
        .with(error: LoremIpsum.paragraph(sentences: 3))
        .with(placeholder: "Some text")
        .with(title: "Long error")
    private let infoTextView = Components.input.textView.default()
        .with(info: LoremIpsum.paragraph(sentences: 2))
        .with(placeholder: "Some text")
        .with(title: "Info")
        .with(titleColor: Theme.Colors.blue)
    private let infoAndErrorTextView = Components.input.textView.default()
        .with(error: LoremIpsum.paragraph(sentences: 2))
        .with(info: LoremIpsum.paragraph(sentences: 2))
        .with(placeholder: "Some text")
        .with(title: "Info and error")
    private let footerTextView = Components.input.textView.default()
        .with(text: "Some text")
        .with(title: "Footer")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([ 
            self.textView,
            self.disableTextView,
            self.errorTextView,
            self.longErrorTextView,
            self.infoTextView,
            self.infoAndErrorTextView
        ], divider: self.divider)
    }
    
    override func setupFooter() {
        super.setupFooter()
        self.addToFooter([
            self.footerTextView
        ])
    }
}
