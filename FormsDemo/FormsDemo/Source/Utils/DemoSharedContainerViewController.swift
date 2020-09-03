//
//  DemoSharedContainerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsInjector
import FormsUtils
import UIKit

// MARK: DemoSharedContainerViewController
class DemoSharedContainerViewController: FormsTableViewController {
    private let textView = Components.input.textView.default()
        .with(title: "Shared JSON")
     
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @Injected
    private var sharedContainer: SharedContainerProtocol // swiftlint:disable:this let_var_whitespace
    
    override func setupView() {
        super.setupView()
        self.readText()
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.textView
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.textView.onTextChanged = Unowned(self) { (_self, text) in
            _self.writeText(text)
        }
    }
    
    private func readText() {
        let data: Data = self.sharedContainer.jsonData ?? Data()
        self.textView.text = String(data: data, encoding: .utf8)
    }
    
    private func writeText(_ text: String?) {
        self.sharedContainer.jsonData = text?.data
    }
}
