//
//  DemoStackContainerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoStackContainerViewController
class DemoStackContainerViewController: TableViewController {
    private lazy var firstContainer = Components.container.stack()
        .with(height: 200)
        .with(items: [self.firstRedView, self.firstGreenView])
    private let firstRedView = Components.container.view()
        .with(backgroundColor: UIColor.red)
    private let firstGreenView = Components.container.view()
        .with(backgroundColor: UIColor.green)
    private lazy var secondContainer = Components.container.stack()
        .with(axis: .vertical)
        .with(height: 200)
        .with(items: [self.secondRedView, self.secondGreenView, self.secondOrangeView])
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
