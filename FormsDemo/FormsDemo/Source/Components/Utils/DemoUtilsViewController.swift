//
//  DemoUtilsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import UIKit

// MARK: DemoUtilsViewController
class DemoUtilsViewController: FormsTableViewController {
    private let customDivider = Components.utils.divider()
        .with(color: Theme.Colors.red)
        .with(height: 44)
     private let confetti = Components.utils.confetti()
        .with(anchors: { [Anchor.to($0).height(100)] })
        .with(color: Theme.Colors.red)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.confetti.start()
        self.confetti.slow(after: 3.5)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.customDivider,
            self.confetti
        ], divider: self.divider)
    }
}
