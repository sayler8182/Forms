//
//  SinglePicker.swift
//  Forms
//
//  Created by Konrad on 10/20/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import UIKit

// MARK: PickerItem
public protocol SinglePickerItem {
    var rawValue: Int { get }
    var title: String { get }
}

// MARK: SinglePicker
open class SinglePicker: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let pickerView = UIPickerView()
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    private var _selected: SinglePickerItem? = nil
    open var selected: SinglePickerItem? {
        get { self._selected }
        set {
            self._selected = newValue
            self.pickerView.selectRow(newValue?.rawValue ?? 0, inComponent: 0, animated: true)
        }
    }
    open var height: CGFloat = 216
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var items: [SinglePickerItem] = [] {
        didSet { self.updateItems() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    
    open var onValueChanged: ((SinglePickerItem) -> Void)?
    
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
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.backgroundView.addSubview(self.pickerView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func updateItems() {
        self.pickerView.reloadAllComponents()
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
}

// MARK: SinglePicker
extension SinglePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        return self.items[row].title
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int) {
        self._selected = self.items[row]
        self.onValueChanged?(self.items[row])
    }
}

// MARK: SinglePicker
public extension SinglePicker {
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(items: [SinglePickerItem]) -> Self {
        self.items = items
        return self
    }
    func with(selected: SinglePickerItem?) -> Self {
        self.selected = selected
        return self
    }
}
