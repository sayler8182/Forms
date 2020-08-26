//
//  DemoCalendarKitCalendarController.swift
//  FormsDemo
//
//  Created by Konrad on 8/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsCalendarKit
import FormsToastKit
import FormsUtils
import UIKit

// MARK: DemoCalendarKitCalendarController
class DemoCalendarKitCalendarController: FormsViewController {
    private let calendar = Components.calendar.calendar()
        .with(date: Date())
    private let sizeButton = Components.button.default()
    
    private let divider = Components.utils.divider()
        .with(height: 50.0)

    private var isCompact: Bool = false
    
    override func setupView() {
        super.setupView()
        self.updateSizeButton(animated: false)
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.calendar, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
        self.view.addSubview(self.sizeButton, with: [
            Anchor.to(self.calendar).topToBottom.offset(16),
            Anchor.to(self.view).bottom.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        self.sizeButton.onClick = Unowned(self) { (_self) in
            _self.isCompact.toggle()
            _self.updateSizeButton()
        }
    }
    
    private func updateSizeButton(animated: Bool = true) {
        self.view.animation(
            animated,
            duration: 0.3,
            animations: {
                self.sizeButton.title = self.isCompact ? "Compact" : "Full"
                let constraint: NSLayoutConstraint? = self.sizeButton.constraint(
                    to: self.calendar,
                    position: .topToBottom)
                if self.isCompact && constraint.isNil {
                    self.sizeButton.anchors([
                        Anchor.to(self.calendar).topToBottom.offset(16)
                    ])
                } else if !self.isCompact && constraint.isNotNil {
                    constraint?.isActive = false
                }
                self.view.layoutIfNeeded()
        })
    }
}
