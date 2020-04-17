//
//  DemoTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoComponent
private class DemoComponent: FormComponent {
    override func componentHeight() -> CGFloat {
        return 44.0
    }
}

// MARK: DemoTableViewController
class DemoTableViewController: TableViewController {
    private let headerRedView = UIView()
        .with(backgroundColor: UIColor.red)
    private let contentRedView = DemoComponent()
        .with(backgroundColor: UIColor.red)
    private let contentGreenView = DemoComponent()
        .with(backgroundColor: UIColor.green)
    private let contentBlueView = DemoComponent()
        .with(backgroundColor: UIColor.blue)
    private let footerRedView = UIView()
        .with(backgroundColor: UIColor.red)
    private let footerGreenView = UIView()
        .with(backgroundColor: UIColor.green)
    
    override func setupHeader() {
        super.setupHeader()
        self.setHeader(self.headerRedView, height: 44.0)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.contentRedView,
            self.contentGreenView,
            self.contentBlueView
        ])
        
        DispatchQueue.main.async {
            for i in 0..<2 {
                let color: UIColor = i.isMultiple(of: 2) ? UIColor.systemPink : UIColor.systemGreen
                let view: FormComponent = DemoComponent()
                    .with(backgroundColor: color)
                self.add(view, animated: .none)
            }
        }
        
        DispatchQueue.main.async {
            for i in 0..<10 {
                let color: UIColor = i.isMultiple(of: 2) ? UIColor.orange : UIColor.yellow
                let view: FormComponent = DemoComponent()
                    .with(backgroundColor: color)
                self.add(view, animated: .automatic)
            }
        }
    }
    
    override func setupFooter() {
        super.setupFooter()
        self.addToFooter([
            self.footerRedView,
            self.footerGreenView
        ], height: 44.0)
    }
}
