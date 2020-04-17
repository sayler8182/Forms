//
//  DemoToastViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoToastViewController
class DemoToastViewController: TableViewController {
    private let defaultToastTopButton = Components.button.primary()
        .with(title: "Default toast top")
    private let defaultToastBottomButton = Components.button.primary()
        .with(title: "Default toast bottom")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.defaultToastTopButton,
            self.defaultToastBottomButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.defaultToastTopButton.onClick = { [unowned self] in
            Toast.new()
                .with(position: .top)
                .with(style: .success)
                .with(title: LoremIpsum.paragraph(sentences: 4))
                .show(in: self.navigationController)
        }
        self.defaultToastBottomButton.onClick = { [unowned self] in
            Toast.new()
                .with(position: .bottom)
                .with(style: .error)
                .with(title: LoremIpsum.paragraph(sentences: 8))
                .show(in: self.navigationController)
        }
    }
}
