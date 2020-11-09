//
//  DatePicker.swift
//  Forms
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import UIKit

// MARK: DatePicker
open class DatePicker: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let pickerView = UIDatePicker()
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var date: Date {
        get { return self.pickerView.date }
        set { self.pickerView.date = newValue }
    }
    open var datePickerMode: UIDatePicker.Mode {
        get { return self.pickerView.datePickerMode }
        set { self.pickerView.datePickerMode = newValue }
    }
    open var locale: Locale? {
        get { return self.pickerView.locale }
        set { self.pickerView.locale = newValue }
    }
    open var height: CGFloat = 216
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var minimumDate: Date? {
        get { return self.pickerView.minimumDate }
        set { self.pickerView.maximumDate = newValue }
    }
    open var minuteInterval: Int {
        get { return self.pickerView.minuteInterval }
        set { self.pickerView.minuteInterval = newValue }
    }
    open var maximumDate: Date? {
        get { return self.pickerView.maximumDate }
        set { self.pickerView.maximumDate = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    @available(iOS 13.4, *)
    open var preferredDatePickerStyle: UIDatePickerStyle {
        get { return self.pickerView.preferredDatePickerStyle }
        set { self.pickerView.preferredDatePickerStyle = newValue }
    }
    open var timeZone: TimeZone! {
        get { return self.pickerView.timeZone }
        set { self.pickerView.timeZone = newValue }
    }
    override open var tintColor: UIColor? {
        get { return self.pickerView.tintColor }
        set { self.pickerView.tintColor = newValue }
    }
    
    open var onValueChanged: ((Date) -> Void)?
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupPickerView()
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
    
    open func setupPickerView() {
        self.pickerView.frame = self.bounds
        self.backgroundView.addSubview(self.pickerView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    override open func setupActions() {
        super.setupActions()
        self.pickerView.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
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
        self.pickerView.frame = self.bounds.with(inset: edgeInset)
        self.pickerView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.pickerView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.pickerView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.pickerView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    @objc
    private func handleValueChanged(datePicker: UIDatePicker) {
        self.onValueChanged?(datePicker.date)
    }
}

// MARK: DatePicker
public extension DatePicker {
    func with(date: Date) -> Self {
        self.date = date
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
    func with(timeZone: TimeZone?) -> Self {
        self.timeZone = timeZone
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
}
