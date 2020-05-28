//
//  DemoLoaderViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import UIKit

// MARK: DemoLoaderViewController
class DemoLoaderViewController: FormsTableViewController {
    private let defaultLoaderButton = Components.button.default()
        .with(title: "Default loader")
    private let titleShortLoaderButton = Components.button.default()
        .with(title: "Custom title short loader")
    private let titleLongLoaderButton = Components.button.default()
        .with(title: "Custom title long loader")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.defaultLoaderButton,
            self.titleShortLoaderButton,
            self.titleLongLoaderButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.defaultLoaderButton.onClick = { [unowned self] in
            Loader.show(in: self.navigationController)
            Utils.delay(2.0, self) { Loader.hide(in: $0.navigationController) }
        }
        self.titleShortLoaderButton.onClick = { [unowned self] in
            Loader.show(
                in: self.navigationController,
                of: TitleLoaderView.self)?
                .setTitle("Short text")
            Utils.delay(2.0, self) { Loader.hide(in: $0.navigationController) }
        }
        self.titleLongLoaderButton.onClick = { [unowned self] in
            let loaderView: TitleLoaderView? = Loader.show(
                in: self.navigationController,
                of: TitleLoaderView.self)
            loaderView?.setTitle(LoremIpsum.paragraph(sentences: 4))
            Utils.delay(2.0, self) { Loader.hide(in: $0.navigationController) }
        }
    }
}

// MARK: TitleLoaderView
private class TitleLoaderView: LoaderView {
    private let activityIndicatorView = Components.other.activityIndicator()
        .with(color: Theme.Colors.red)
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(color: Theme.Colors.red)
        .with(font: Theme.Fonts.bold(ofSize: 14))
        .with(numberOfLines: 3)
    
    required init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = Theme.Colors.secondaryBackground
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    override func add(to parent: UIView) {
        parent.addSubview(self, with: [
            Anchor.to(parent).center,
            Anchor.to(self).size(80).priority(.defaultLow),
            Anchor.to(parent).leading.offset(16).greaterThanOrEqual,
            Anchor.to(parent).trailing.offset(16).lessThanOrEqual
        ])
        self.addSubview(self.activityIndicatorView, with: [
            Anchor.to(self).top.offset(16),
            Anchor.to(self).centerX
        ])
        self.addSubview(self.titleLabel, with: [
            Anchor.to(self.activityIndicatorView).topToBottom.offset(8),
            Anchor.to(self).horizontal.offset(16),
            Anchor.to(self).bottom.offset(16)
        ])
    }
    
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
        guard let coverView = self.coverView else { return }
        coverView.backgroundView.alpha = 0
        self.frame.origin.y = coverView.frame.height
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                coverView.backgroundView.alpha = 1
                self.center = coverView.center
        }, completion: completion)
    }
    
    override func hide(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
        guard let coverView = self.coverView else { return }
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                coverView.backgroundView.alpha = 0
                self.frame.origin.y = -coverView.frame.height
        }, completion: completion)
    }
}
