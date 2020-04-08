//
//  DemoLoaderViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoLoaderViewController
class DemoLoaderViewController: TableViewController {
    private let defaultLoaderButton = Components.button.primary()
        .with(title: "Default loader")
    private let titleShortLoaderButton = Components.button.primary()
        .with(title: "Custom title short loader")
    private let titleLongLoaderButton = Components.button.primary()
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
            self.hideLoaderAfterSomeTime()
        }
        self.titleShortLoaderButton.onClick = { [unowned self] in
            let loaderView: TitleLoaderView? = Loader.show(
                in: self.navigationController,
                of: TitleLoaderView.self)
            loaderView?.setTitle("Short text")
            self.hideLoaderAfterSomeTime()
        }
        self.titleLongLoaderButton.onClick = { [unowned self] in
            let loaderView: TitleLoaderView? = Loader.show(
                in: self.navigationController,
                of: TitleLoaderView.self)
            loaderView?.setTitle(LoremIpsum.paragraph(sentences: 4))
            self.hideLoaderAfterSomeTime()
        }
    }
    
    private func hideLoaderAfterSomeTime() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Loader.hide(in: self.navigationController)
        }
    }
}

// MARK: TitleLoaderView
private class TitleLoaderView: LoaderView {
    private let activityIndicatorView = UIActivityIndicatorView()
        .with(color: UIColor.red)
        .with(isAnimating: true)
        .with(style: .medium)
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
        self.animate(
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
        self.animate(
            animated,
            duration: 0.3,
            animations: {
                coverView.backgroundView.alpha = 0
                self.frame.origin.y = -coverView.frame.height
        }, completion: completion)
    }
}
