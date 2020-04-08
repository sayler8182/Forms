//
//  DemoModalViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoModalViewController
class DemoModalViewController: TableViewController {
    private let titleShortModalButton = Components.button.primary()
        .with(title: "Title short modal")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.titleShortModalButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.titleShortModalButton.onClick = { [unowned self] in
            let modalView = Modal.show(
                in: self.navigationController,
                of: TitleModalView.self)
            modalView?.setTitle("Short title")
        }
    }
}

// TitleModalView
private class TitleModalView: ModalView {
    private let titleLabel = UILabel()
        .with(font: UIFont.boldSystemFont(ofSize: 14))
        .with(numberOfLines: 3)
        .with(textAlignment: .center)
        .with(textColor: UIColor.red)
    
    required init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func setupActions() {
        super.setupActions()
        self.onDismiss = { [unowned self] (_) in
            Modal.hide(in: self.context, of: TitleModalView.self)
        }
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    override func add(to parent: UIView) {
        parent.addSubview(self, with: [
            Anchor.to(parent).center,
            Anchor.to(parent).leading.offset(16).greaterThanOrEqual,
            Anchor.to(parent).trailing.offset(16).lessThanOrEqual
        ])
        self.addSubview(self.titleLabel, with: [
            Anchor.to(self).top.offset(16),
            Anchor.to(self).leading.offset(16),
            Anchor.to(self).trailing.offset(16),
            Anchor.to(self).bottom.offset(16)
        ])
    }
    
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
        guard let coverView = self.coverView else { return }
        coverView.backgroundView.alpha = 0
        self.frame.origin.x = coverView.frame.width
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                coverView.backgroundView.alpha = 1
                self.center = coverView.center
        }, completion: completion)
    }
    
    override  func hide(animated: Bool,
                        completion: ((Bool) -> Void)? = nil) {
        guard let coverView = self.coverView else { return }
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                coverView.backgroundView.alpha = 0
                self.frame.origin.x = -coverView.frame.width
        }, completion: completion)
    }
}
