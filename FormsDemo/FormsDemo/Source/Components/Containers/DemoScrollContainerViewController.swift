//
//  DemoScrollContainerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoScrollContainerViewController
class DemoScrollContainerViewController: TableViewController {
    private lazy var firstContainer = Components.container.scroll()
        .with(height: 200)
        .with(items: [self.firstRedView, self.firstGreenView])
    private let firstRedView = Components.container.view()
        .with(backgroundColor: UIColor.red)
    private let firstGreenView = Components.container.view()
        .with(backgroundColor: UIColor.green)
    private lazy var secondContainer = Components.container.scroll()
        .with(bounces: false)
        .with(automaticInterval: 2.0)
        .with(height: 200)
        .with(isAutomatic: true)
        .with(items: [self.secondRedView, self.secondGreenView, self.secondOrangeView])
        .with(paddingEdgeInset: UIEdgeInsets(horizontal: 8))
        .with(pageIsHidden: true)
        .with(scrollDirection: .vertical)
    private let secondRedView = Components.container.view()
        .with(backgroundColor: UIColor.red)
    private let secondGreenView = Components.container.view()
        .with(backgroundColor: UIColor.green)
    private let secondOrangeView = Components.container.view()
        .with(backgroundColor: UIColor.orange)
    
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