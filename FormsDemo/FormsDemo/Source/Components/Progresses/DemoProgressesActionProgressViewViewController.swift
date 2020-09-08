//
//  DemoProgressesActionProgressViewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoProgressesActionProgressViewViewController
class DemoProgressesActionProgressViewViewController: FormsTableViewController {
     private lazy var action1ProgressView = Components.progress.action()
        .with(items: [
            ActionProgressItem(icon: { UIImage.from(name: "square.and.arrow.up") }),
            ActionProgressItem(icon: { UIImage.from(name: "square.and.arrow.up.fill") }),
            ActionProgressItem(icon: { UIImage.from(name: "square.and.arrow.down") }),
            ActionProgressItem(icon: { UIImage.from(name: "square.and.arrow.down.fill") }),
            ActionProgressItem(icon: { UIImage.from(name: "square.and.arrow.up.on.square") })
        ])
        .with(progress: self.progress)
    private lazy var action2ProgressView = Components.progress.action()
        .with(items: (0..<(UIScreen.main.bounds.width / 30.0).asInt).map { _ in
            ActionProgressItem(
                key: UUID().uuidString,
                icon: { ActionProgressItem.empty },
                selectedIcon: { UIImage.from(name: "square.and.arrow.up") })
        })
        .with(progress: self.progress)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private var progress: CGFloat = 0.3
    private var timer: Timer? = nil
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.action1ProgressView,
            self.action2ProgressView
        ], divider: self.divider)
    }
    
    override func setTheme() {
        super.setTheme()
        self.action1ProgressView.backgroundColors = .init(Theme.Colors.red)
        self.action2ProgressView.tintColors = ActionProgressView.State<UIColor?>(Theme.Colors.primaryDark)
            .with(selected: Theme.Colors.red)
    }
    
    override func setupActions() {
        super.setupActions()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.updateProgresses()
        }
    }
    
    private func updateProgresses() {
        self.progress = CGFloat(Int((self.progress + 0.02) * 100) % 101) / 100.0
        let views: [FormsComponentWithProgress] = [
            self.action1ProgressView,
            self.action2ProgressView
        ]
        views.forEach { $0.setProgress(self.progress, animated: true) }
    }
}
