//
//  DemoGridViewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import UIKit

// MARK: DemoGridViewViewController
class DemoGridViewViewController: FormsTableViewController {
    private lazy var container = Components.container.grid()
        .with(anchors: { [Anchor.to($0).height(200)] })
        .with(itemsPerSection: 2)
        .with(items: [self.redView, self.greenView, self.orangeView])
    private let redView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let greenView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
    private let orangeView = Components.container.view()
        .with(backgroundColor: Theme.Colors.orange)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.container
        ], divider: self.divider)
    }
}
