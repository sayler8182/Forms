//
//  DemoViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoViewViewController
class DemoViewController: ViewController {
    private let centerView = UIView()
        .with(width: 320, height: 44)
        .with(backgroundColor: UIColor.red)
    private let bottomView = UIView()
        .with(width: 320, height: 44)
        .with(backgroundColor: UIColor.green)
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.centerView, with: [
            Anchor.to(self.view).center(300, 44)
        ])
        self.view.addSubview(self.bottomView, with: [
            Anchor.to(self.centerView).topToBottom.offset(16),
            Anchor.to(self.centerView).horizontal,
            Anchor.to(self.centerView).height
        ])
    }
}
