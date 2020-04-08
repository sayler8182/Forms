//
//  TitleTextField.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TitleTextField
open class TitleTextField: TextField {
    override open func setupBackgroundView() {
        super.setupBackgroundView()
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom.lessThanOrEqual
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
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
        ])
    }
    
    override open func setupUnderscoreView() {
        super.setupUnderscoreView()
        self.backgroundView.addSubview(self.underscoreView, with: [
            Anchor.to(self.textField).topToBottom.offset(2),
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
            Anchor.to(self.backgroundView).bottom.offset(self.paddingEdgeInset.bottom).priority(.defaultHigh)
        ])
    }
    
    override open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.titleLabel.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.titleLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.titleLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.textField.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.textField.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.underscoreView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.underscoreView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.errorLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.errorLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.infoLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.infoLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.infoLabel.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
    }
}
