//
//  Slider.swift
//  Forms
//
//  Created by Konrad on 10/22/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtilsUI
import UIKit

// MARK: Slider
open class Slider: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let slider = UISlider()
    
    open var animationTime: TimeInterval = 0.2
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var maximumTrackTintColor: UIColor? {
        get { return self.slider.maximumTrackTintColor }
        set { self.slider.maximumTrackTintColor = newValue }
    }
    open var maxValue: Double {
        get { return self.slider.maximumValue.asDouble }
        set { self.slider.maximumValue = newValue.asFloat }
    }
    open var minimumTrackTintColor: UIColor? {
        get { return self.slider.minimumTrackTintColor }
        set { self.slider.minimumTrackTintColor = newValue }
    }
    open var minValue: Double {
        get { return self.slider.minimumValue.asDouble }
        set { self.slider.minimumValue = newValue.asFloat }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    override open var tintColor: UIColor? {
        get { return self.slider.tintColor }
        set { self.slider.tintColor = newValue }
    }
    open var thumbTintColor: UIColor? {
        get { return self.slider.thumbTintColor }
        set { self.slider.thumbTintColor = newValue }
    }
    private var _value: Double = 0
    open var value: Double {
        get { return self._value }
        set {
            self._value = newValue
            self.setValue(newValue, animated: false)
        }
    }
    
    public var onValueChanged: ((Double) -> Void)? = nil
    
    override public func setupView() {
        self.setupBackgroundView()
        self.setupSlider()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.slider.addTarget(self, action: #selector(handleOnValueChanged), for: .valueChanged)
    }
    
    @objc
    private func handleOnValueChanged(_ sender: UISlider) {
        self._value = sender.value.asDouble
        self.onValueChanged?(self._value)
    }
    
    open func setValue(_ value: Double,
                       animated: Bool) {
        self.animation(
            animated,
            duration: self.animationTime,
            animations: {
                self.slider.setValue(value.asFloat, animated: animated)
        })
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupSlider() {
        self.slider.frame = self.bounds
        self.backgroundView.addSubview(self.slider, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    open func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.slider.frame = self.bounds.with(inset: edgeInset)
        self.slider.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.slider.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.slider.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.slider.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Builder
public extension Slider {
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(maximumTrackTintColor: UIColor?) -> Self {
        self.maximumTrackTintColor = maximumTrackTintColor
        return self
    }
    func with(maxValue: Double) -> Self {
        self.maxValue = maxValue
        return self
    }
    func with(minimumTrackTintColor: UIColor?) -> Self {
        self.minimumTrackTintColor = minimumTrackTintColor
        return self
    }
    func with(minValue: Double) -> Self {
        self.minValue = minValue
        return self
    }
    func with(thumbTintColor: UIColor?) -> Self {
        self.thumbTintColor = thumbTintColor
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
    func with(value: Double) -> Self {
        self.value = value
        return self
    }
}
