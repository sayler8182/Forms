//
//  DemoOthersViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoOthersViewController
@available(iOS 13.0, *)
class DemoOthersViewController: FormsTableViewController {
    private let activityIndicator = Components.other.activityIndicator()
            .with(backgroundColor: UIColor.lightGray)
            .with(color: UIColor.white)
            .with(height: 60)
            .with(style: .large)
     
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.activityIndicator
        ], divider: self.divider)
    }
}
