//
//  DemoProgressesProgressBarViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoProgressesProgressBarViewController
class DemoProgressesProgressBarViewController: FormsTableViewController {
    private lazy var navigationProgressBar = Components.progress.default()
        .with(progress: self.progress)
     private lazy var progressBar = Components.progress.default()
        .with(marginTop: 5.0)
        .with(progress: self.progress)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private var progress: CGFloat = 0.3
    private var timer: Timer? = nil
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.progressBar
        ], divider: self.divider)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationProgressBar(self.navigationProgressBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.updateProgresses()
        }
    }
    
    private func updateProgresses() {
        self.progress = CGFloat(Int((self.progress + 0.05) * 100) % 101) / 100.0
        let views: [FormsComponentWithProgress] = [
            self.navigationProgressBar,
            self.progressBar
        ]
        views.forEach { $0.setProgress(self.progress, animated: true) }
    }
}
