//
//  DemoPageContainerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoPageContainerViewController
class DemoPageContainerViewController: FormsTableViewController {
    private lazy var firstContainer = Components.container.page()
        .with(height: 200)
        .with(items: [self.firstRedView, self.firstGreenView])
    private let firstRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let firstGreenView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
    private lazy var secondContainer = Components.container.page()
        .with(bounces: false)
        .with(automaticInterval: 2.0)
        .with(height: 200)
        .with(isAutomatic: true)
        .with(items: [self.secondRedView, self.secondGreenView, self.secondOrangeView])
        .with(paddingHorizontal: 8)
        .with(pageIsHidden: true)
        .with(scrollDirection: .vertical)
    private let secondRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let secondGreenView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
    private let secondOrangeView = Components.container.view()
        .with(backgroundColor: Theme.Colors.orange)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.firstContainer,
            self.secondContainer
        ], divider: self.divider)
    }
}
