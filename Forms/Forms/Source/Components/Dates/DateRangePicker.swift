//
//  DateRangePicker.swift
//  Forms
//
//  Created by Konrad on 10/22/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import UIKit

// MARK: DateRangePicker
open class DateRangePicker: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let pickerFromView = UIDatePicker()
    public let pickerToView = UIDatePicker()
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var dateFrom: Date {
        get { return self.pickerFromView.date }
        set { self.pickerFromView.date = newValue }
    }
    open var dateTo: Date {
        get { return self.pickerToView.date }
        set { self.pickerToView.date = newValue }
    }
    open var datePickerMode: UIDatePicker.Mode {
        get { return self.pickerFromView.datePickerMode }
        set {
            self.pickerFromView.datePickerMode = newValue
            self.pickerToView.datePickerMode = newValue
        }
    }
    open var locale: Locale? {
        get { return self.pickerFromView.locale }
        set {
            self.pickerFromView.locale = newValue
            self.pickerToView.locale = locale
        }
    }
    open var height: CGFloat = 216
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var minimumDate: Date? {
        get { return self.pickerFromView.minimumDate }
        set { self.pickerFromView.maximumDate = newValue }
    }
    open var minuteInterval: Int {
        get { return self.pickerFromView.minuteInterval }
        set {
            self.pickerFromView.minuteInterval = newValue
            self.pickerToView.minuteInterval = newValue
        }
    }
    open var maximumDate: Date? {
        get { return self.pickerToView.maximumDate }
        set { self.pickerToView.maximumDate = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    @available(iOS 13.4, *)
    open var preferredDatePickerStyle: UIDatePickerStyle {
        get { return self.pickerFromView.preferredDatePickerStyle }
        set {
            self.pickerFromView.preferredDatePickerStyle = newValue
            self.pickerToView.preferredDatePickerStyle = newValue
        }
    }
    open var space: CGFloat = 8 {
        didSet { self.updateSpace() }
    }
    override open var tintColor: UIColor? {
        get { return self.pickerFromView.tintColor }
        set {
            self.pickerFromView.tintColor = newValue
            self.pickerToView.tintColor = newValue
        }
    }
    
    open var onValueChanged: ((Date, Date) -> Void)?
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupPickersView()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupPickersView() {
        self.pickerFromView.frame = self.bounds
        self.backgroundView.addSubview(self.pickerFromView, with: [
            Anchor.to(self.backgroundView).vertical,
            Anchor.to(self.backgroundView).leading
        ])
        self.pickerToView.frame = self.bounds
        self.backgroundView.addSubview(self.pickerToView, with: [
            Anchor.to(self.pickerFromView).leadingToTrailing.offset(self.space),
            Anchor.to(self.backgroundView).vertical,
            Anchor.to(self.backgroundView).trailing,
            Anchor.to(self.pickerFromView).width
        ])
    }
    
    override open func setupActions() {
        super.setupActions()
        self.pickerFromView.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        self.pickerToView.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
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
        self.pickerFromView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.pickerFromView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.pickerFromView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.pickerToView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.pickerToView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.pickerToView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updateSpace() {
        let space: CGFloat = self.space
        self.pickerFromView.constraint(to: self.pickerToView, position: .trailing)?.constant = space
    }
    
    @objc
    private func handleValueChanged(datePicker: UIDatePicker) {
        if self.pickerFromView.date > self.pickerToView.date {
            if datePicker === self.pickerFromView {
                self.pickerFromView.date = self.pickerToView.date
            } else if datePicker === self.pickerToView {
                self.pickerToView.date = self.pickerFromView.date
            }
        }
        self.onValueChanged?(self.pickerFromView.date, self.pickerToView.date)
    }
}

// MARK: DateRangePicker
public extension DateRangePicker {
    func with(dateFrom: Date) -> Self {
        self.dateFrom = dateFrom
        return self
    }
    func with(dateTo: Date) -> Self {
        self.dateTo = dateTo
        return self
    }
    func with(datePickerMode: UIDatePicker.Mode) -> Self {
        self.datePickerMode = datePickerMode
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(locale: Locale?) -> Self {
        self.locale = locale
        return self
    }
    func with(minimumDate: Date?) -> Self {
        self.minimumDate = minimumDate
        return self
    }
    func with(minuteInterval: Int) -> Self {
        self.minuteInterval = minuteInterval
        return self
    }
    func with(maximumDate: Date?) -> Self {
        self.maximumDate = maximumDate
        return self
    }
    @available(iOS 13.4, *)
    func with(preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
}
