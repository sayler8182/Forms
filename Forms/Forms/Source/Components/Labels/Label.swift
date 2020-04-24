//
//  Label.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit
import Utils

// MARK: Label
open class Label: FormComponent, Clickable {
    public let backgroundView = UIView()
    public let textLabel = UILabel()
        .with(isUserInteractionEnabled: true)
    public let textGestureRecognizer = UILongPressGestureRecognizer()
    
    open var alignment: NSTextAlignment {
        get { return self.textLabel.textAlignment }
        set { self.textLabel.textAlignment = newValue }
    }
    open var animationTime: TimeInterval = 0.2
    open var attributedText: AttributedString? {
        didSet {
            self.attributedText?.label = self.textLabel
            self.textLabel.attributedText = self.attributedText?.string
            self.textGestureRecognizer.isEnabled = self.attributedText.isNotNil
        }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var color: UIColor? {
        get { return self.textLabel.textColor }
        set { self.textLabel.textColor = newValue }
    }
    open var edgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateEdgeInset() }
    }
    open var font: UIFont? {
        get { return self.textLabel.font }
        set { self.textLabel.font = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension
    override open var isUserInteractionEnabled: Bool {
        get { return self.textLabel.isUserInteractionEnabled }
        set { self.textLabel.isUserInteractionEnabled = newValue }
    }
    open var maxHeight: CGFloat = CGFloat.greatestConstraintConstant {
        didSet { self.updateMaxHeight() }
    }
    open var minHeight: CGFloat = 0.0 {
        didSet { self.updateMinHeight() }
    }
    open var numberOfLines: Int {
        get { return self.textLabel.numberOfLines }
        set { self.textLabel.numberOfLines = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var text: String? {
        get { return self.textLabel.text }
        set { self.textLabel.text = newValue }
    }
    
    public var onClick: (() -> Void)? = nil {
        didSet { self.textGestureRecognizer.isEnabled = self.onClick.isNotNil }
    }
    
    override open func setupView() {
        self.setupComponentView()
        self.setupBackgroundView()
        self.setupTextLabel()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    override open func setupActions() {
        self.textGestureRecognizer.minimumPressDuration = 0.0
        self.textGestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.textGestureRecognizer.isEnabled = false
        self.textLabel.addGestureRecognizer(self.textGestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UILongPressGestureRecognizer) {
        let attributedStringPart = self.attributedText?.attributedStringPart(recognizer: recognizer)
        let onClick = attributedStringPart?.onClick ?? self.onClick
        
        switch recognizer.state {
        case .began,
             .changed:
            let alpha: CGFloat = onClick != nil ? 0.3 : 1.0
            self.textLabel.setAlpha(alpha: alpha, duration: self.animationTime)
        case .ended:
            self.textLabel.setAlpha(alpha: 1, duration: self.animationTime)
            let point: CGPoint = recognizer.location(in: self.textLabel)
            if self.textLabel.bounds.contains(point) {
                onClick?()
            }
        default:
            break
        }
    }
    
    private func setupComponentView() {
        self.anchors([
            Anchor.to(self).height(self.minHeight).greaterThanOrEqual,
            Anchor.to(self).height(self.maxHeight).lessThanOrEqual
        ])
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupTextLabel() {
        self.textLabel.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.textLabel, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func updateEdgeInset() {
        let edgeInset: UIEdgeInsets = self.edgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.textLabel.frame = self.bounds.with(inset: edgeInset)
        self.textLabel.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.textLabel.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.textLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.textLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateMaxHeight() {
        let maxHeight: CGFloat = self.maxHeight
        self.constraint(position: .height, relation: .lessThanOrEqual)?.constant = maxHeight
    }
    
    private func updateMinHeight() {
        let minHeight: CGFloat = self.minHeight
        self.constraint(position: .height, relation: .greaterThanOrEqual)?.constant = minHeight
    }
}

// MARK: Label
public extension Label {
    func height(for width: CGFloat) -> CGFloat {
        let height: CGFloat = self.textLabel.height(for: width)
        let maxHeight: CGFloat = String.empty.height(for: width, font: self.textLabel.font) * CGFloat(self.numberOfLines)
        return min(min(maxHeight, height), self.maxHeight)
    }
    
    func width(for height: CGFloat) -> CGFloat {
        return self.textLabel.width(for: height)
    }
}

// MARK: Builder
public extension Label {
    func with(alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    func with(attributedText: AttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    } 
    func with(color: UIColor?) -> Self {
        self.color = color
        return self
    }
    func with(edgeInset: UIEdgeInsets) -> Self {
        self.edgeInset = edgeInset
        return self
    }
    func with(font: UIFont?) -> Self {
        self.font = font
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    @objc
    override func with(isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    func with(maxHeight: CGFloat) -> Self {
        self.maxHeight = maxHeight
        return self
    }
    func with(minHeight: CGFloat) -> Self {
        self.minHeight = minHeight
        return self
    }
    func with(numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    func with(paddingEdgeInset: UIEdgeInsets) -> Self {
        self.paddingEdgeInset = paddingEdgeInset
        return self
    }
    func with(text: String?) -> Self {
        self.text = text
        return self
    }
}
