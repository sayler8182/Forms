//
//  Button.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtilsUI
import UIKit

// MARK: Button
open class Button: ClickableView {
    public let clickableView = UnShimmerableView()
    public let borderView = UnShimmerableView()
    public let titleLabel = UnShimmerableLabel()
    
    open var borderColors: State<UIColor?> = State<UIColor?>(UIColor.clear) {
        didSet { self.updateState() }
    }
    open var borderWidth: CGFloat {
        get { return self.borderView.layer.borderWidth }
        set { self.borderView.layer.borderWidth = newValue }
    }
    open var cornerRadius: CGFloat {
        get { return self.backgroundView.layer.cornerRadius }
        set {
            self.backgroundView.layer.cornerRadius = newValue
            self.borderView.layer.cornerRadius = newValue
        }
    }
    open var image: UIImage? = nil {
        didSet { self.updateImage() }
    }
    open var imageSize: CGSize? = nil {
        didSet { self.updateImage() }
    }
    open var lineBreakMode: NSLineBreakMode {
        get { return self.titleLabel.lineBreakMode }
        set { self.titleLabel.lineBreakMode = newValue }
    }
    open var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy {
        get { return self.titleLabel.lineBreakStrategy }
        set { self.titleLabel.lineBreakStrategy = newValue }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleAttributed: NSAttributedString? {
        get { return self.titleLabel.attributedText }
        set { self.titleLabel.attributedText = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 14)) {
        didSet { self.updateState() }
    }
    open var titleNumberOfLines: Int {
        get { return self.titleLabel.numberOfLines }
        set { self.titleLabel.numberOfLines = newValue }
    }
    open var titleTextAlignment: NSTextAlignment {
        get { return self.titleLabel.textAlignment }
        set { self.titleLabel.textAlignment = newValue }
    }
    
    override open func setupView() {
        self.setupClickableView()
        self.setupBorderView()
        self.setupTitleLabel()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    open func setupClickableView() {
        self.content = self.clickableView
    }
    
    open func setupBorderView() {
        self.borderView.frame = self.clickableView.bounds
        self.clickableView.addSubview(self.borderView, with: [
            Anchor.to(self.clickableView).fill
        ])
    }
    
    open func setupTitleLabel() {
        self.titleLabel.frame = self.clickableView.bounds
        self.clickableView.addSubview(self.titleLabel, with: [
            Anchor.to(self.clickableView).fill
        ])
    }
    
    open func updateImage() {
        guard let image: UIImage = self.image else { return }
        guard let imageSize: CGSize = self.imageSize else { return }
        self.titleAttributed = NSAttributedString(
            attachment: NSTextAttachment(
                image: image,
                bounds: CGRect(
                    origin: CGPoint.zero,
                    size: imageSize)))
    }
    
    override open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.titleLabel.frame = self.clickableView.bounds.with(inset: edgeInset)
        self.titleLabel.constraint(to: self.clickableView, position: .top)?.constant = edgeInset.top
        self.titleLabel.constraint(to: self.clickableView, position: .bottom)?.constant = -edgeInset.bottom
        self.titleLabel.constraint(to: self.clickableView, position: .leading)?.constant = edgeInset.leading
        self.titleLabel.constraint(to: self.clickableView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    override open func setStateAnimation(_ state: FormsComponentStateType) {
        super.setStateAnimation(state)
        self.borderView.layer.borderColor = self.borderColors.value(for: state)?.cgColor
        self.titleLabel.textColor = self.titleColors.value(for: state)
        self.titleLabel.font = self.titleFonts.value(for: state)
        self.loaderView.color = self.titleColors.value(for: state)
    }
    
    override open func addLoader(animated: Bool,
                                 animations: (() -> Void)? = nil,
                                 completion: ((Bool) -> Void)? = nil) {
        super.addLoader(
            animated: animated,
            animations: {
                self.titleLabel.alpha = 0
            },
            completion: { status in
                self.titleLabel.isHidden = status
            })
    }
    
    override open func removeLoader(animated: Bool,
                                    animations: (() -> Void)? = nil,
                                    completion: ((Bool) -> Void)? = nil) {
        self.titleLabel.isHidden = false
        super.removeLoader(
            animated: animated,
            animations: {
                self.titleLabel.alpha = 1
            },
            completion: { _ in })
    }
}

// MARK: Builder
public extension Button {
    @objc
    override func with(borderColor: UIColor?) -> Self {
        self.borderColors = State<UIColor?>(borderColor)
        return self
    }
    func with(borderColors: State<UIColor?>) -> Self {
        self.borderColors = borderColors
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }
    func with(imageSize: CGSize?) -> Self {
        self.imageSize = imageSize
        return self
    }
    func with(lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }
    func with(lineBreakStrategy: NSParagraphStyle.LineBreakStrategy) -> Self {
        self.lineBreakStrategy = lineBreakStrategy
        return self
    }
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
    func with(titleAttributed: AttributedString?) -> Self {
        self.titleAttributed = titleAttributed?.string
        return self
    }
    func with(titleAttributed: NSAttributedString?) -> Self {
        self.titleAttributed = titleAttributed
        return self
    }
    func with(titleColor: UIColor?) -> Self {
        self.titleColors = State<UIColor?>(titleColor)
        return self
    }
    func with(titleColors: State<UIColor?>) -> Self {
        self.titleColors = titleColors
        return self
    }
    func with(titleFont: UIFont) -> Self {
        self.titleFonts = State<UIFont>(titleFont)
        return self
    }
    func with(titleFonts: State<UIFont>) -> Self {
        self.titleFonts = titleFonts
        return self
    }
    func with(titleNumberOfLines: Int) -> Self {
        self.titleNumberOfLines = titleNumberOfLines
        return self
    }
    func with(titleTextAlignment: NSTextAlignment) -> Self {
        self.titleTextAlignment = titleTextAlignment
        return self
    }
}
