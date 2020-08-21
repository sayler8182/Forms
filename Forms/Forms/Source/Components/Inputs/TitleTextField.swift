//
//  TitleTextField.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: TitleTextField
open class TitleTextField: TextField {
    open var isBottomDynamic: Bool = true {
        didSet { self.updateIsBottomDynamic() }
    }
    
    override open func setupBackgroundView() {
        super.setupBackgroundView()
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom.greaterThanOrEqual.priority(.defaultLow)
        ])
    }
    
    override open func setupTitleLabel() {
        super.setupTitleLabel()
        self.backgroundView.addSubview(self.titleLabel, with: [
            Anchor.to(self.backgroundView).top.offset(self.paddingEdgeInset.top),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
        ])
    }
    
    override open func setupTextField() {
        super.setupTextField()
        self.backgroundView.addSubview(self.textField, with: [
            Anchor.to(self.titleLabel).topToBottom.offset(2),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading)
        ])
    }
    
    override open func setupActionContainerView() {
        super.setupActionContainerView()
        self.backgroundView.addSubview(self.actionContainerView, with: [
            Anchor.to(self.titleLabel).topToBottom.offset(2),
            Anchor.to(self.textField).leadingToTrailing.greaterThanOrEqual,
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
        ])
        self.actionContainerView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override open func setupUnderscoreView() {
        super.setupUnderscoreView()
        self.backgroundView.addSubview(self.underscoreView, with: [
            Anchor.to(self.textField).topToBottom.offset(2),
            Anchor.to(self.actionContainerView).topToBottom.offset(2),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing),
            Anchor.to(self.underscoreView).height(1.0)
        ])
    }
    
    override open func setupErrorLabel() {
        super.setupErrorLabel()
        self.backgroundView.addSubview(self.errorLabel, with: [
            Anchor.to(self.underscoreView).topToBottom.offset(2),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
        ])
    }
    
    override open func setupInfoLabel() {
        super.setupInfoLabel()
        self.backgroundView.addSubview(self.infoLabel, with: [
            Anchor.to(self.errorLabel).topToBottom,
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing),
            Anchor.to(self.backgroundView).bottom.offset(self.paddingEdgeInset.bottom)
        ])
    }
    
    override open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.titleLabel.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.titleLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.titleLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.textField.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.actionContainerView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.underscoreView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.underscoreView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.errorLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.errorLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.infoLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.infoLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.infoLabel.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
    }
    
    open func updateIsBottomDynamic() {
        self.backgroundView.constraint(to: self, position: .bottom)?.isActive = false
        if self.isBottomDynamic {
            self.backgroundView.anchors([
                Anchor.to(self).bottom.greaterThanOrEqual.priority(.defaultLow)
            ])
        } else if !self.isBottomDynamic {
            self.backgroundView.anchors([
                Anchor.to(self).bottom.greaterThanOrEqual
            ])
        }
    }
}

// MARK: Builder
public extension TitleTextField {
    func with(isBottomDynamic: Bool) -> Self {
        self.isBottomDynamic = isBottomDynamic
        return self
    }
}
