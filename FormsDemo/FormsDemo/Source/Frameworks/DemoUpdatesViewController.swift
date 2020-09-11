//
//  DemoUpdatesViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/9/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsInjector
import FormsUpdates
import FormsUtils
import UIKit

// MARK: DemoUpdatesViewController
class DemoUpdatesViewController: FormsTableViewController {
    private let checkButton = Components.button.default()
        .with(title: "Check")
    private let cancelButton = Components.button.default()
        .with(title: "Cancel")
    private let postponeButton = Components.button.default()
        .with(title: "Postpone")
    private let resetButton = Components.button.default()
    .with(title: "Reset")
    private let statusLabel = Components.label.default()
        .with(marginEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @Injected
    private var updates: UpdatesProtocol // swiftlint:disable:this let_var_whitespace
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.checkButton,
            self.cancelButton,
            self.postponeButton,
            self.resetButton,
            self.statusLabel
        ], divider: self.divider)
        self.updateStatus()
    }
    
    override func setupActions() {
        super.setupActions()
        self.checkButton.onClick = Unowned(self) { (_self) in
            _self.check()
        }
        self.cancelButton.onClick = Unowned(self) { (_self) in
            _self.checkAndCancel()
        }
        self.postponeButton.onClick = Unowned(self) { (_self) in
            _self.postpone()
        }
        self.resetButton.onClick = Unowned(self) { (_self) in
            _self.reset()
        }
    }
    
    private func updateStatus(_ status: UpdatesStatus? = nil) {
        guard let status = status else {
            self.statusLabel.text = "Check status"
            return
        }
        switch status {
        case .newVersion(let old, let new):
            self.statusLabel.text = String(
                format: "Old version: %@, New version: %@",
                old?.description ?? "",
                new.description)
        case .noChanges:
            self.statusLabel.text = "No changes"
        case .postponed:
            self.statusLabel.text = "Postponed"
        case .undefined:
            self.statusLabel.text = "Undefined"
        }
    }
    
    private func check() {
        self.updates.check { [weak self] (status) in
            guard let `self` = self else { return }
            self.updateStatus(status)
        }
    }
    
    private func checkAndCancel() {
        let task = self.updates.check { [weak self] (status) in
            guard let `self` = self else { return }
            self.updateStatus(status)
        }
        task.cancel()
    }
    
    private func postpone() {
        self.updates.postpone()
        self.updates.check { [weak self] (status) in
            guard let `self` = self else { return }
            self.updateStatus(status)
        }
    }
    
    private func reset() {
        self.updates.markAsChecked()
        self.updateStatus()
    }
}
