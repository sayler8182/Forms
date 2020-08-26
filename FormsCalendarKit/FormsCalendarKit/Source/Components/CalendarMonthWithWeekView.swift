//
//  CalendarMonthWithWeekView.swift
//  FormsCalendarKit
//
//  Created by Konrad on 8/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: CalendarMonthWithWeekView
open class CalendarMonthWithWeekView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let weekView = Components.calendar.week()
    public let monthView = Components.calendar.month()

    open var animationTime: TimeInterval {
        get { return self.monthView.animationTime }
        set {
            self.weekView.animationTime = newValue
            self.monthView.animationTime = newValue
        }
    }
    open var backgroundColors: CalendarMonthView.State<UIColor?> {
        get { return self.monthView.backgroundColors }
        set {
            self.weekView.backgroundColor = newValue.value(for: .active)
            self.monthView.backgroundColors = newValue
        }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var date: Date? {
        get { return self.monthView.date }
        set { self.monthView.date = newValue }
    }
    open var itemSize: CGFloat {
        get { return self.monthView.itemSize }
        set { self.monthView.itemSize = newValue }
    }
    override open var isBatchUpdateInProgress: Bool {
        get { return self.monthView.isBatchUpdateInProgress }
        set {
            self.weekView.isBatchUpdateInProgress = newValue
            self.monthView.isBatchUpdateInProgress = newValue
        }
    }
    open var isEnabled: Bool {
        get { return self.monthView.isEnabled }
        set { self.monthView.isEnabled = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var month: Month {
        get { return self.monthView.month }
        set { self.monthView.month = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var selectedDates: [Date] {
        get { return self.monthView.selectedDates }
        set { self.monthView.selectedDates = newValue }
    }
    open var selectionType: CalendarMonthView.SelectionType {
        get { return self.monthView.selectionType }
        set { self.monthView.selectionType = newValue }
    }
    open var settings: CalendarSettings {
        get { return self.monthView.settings }
        set {
            self.weekView.settings = newValue
            self.monthView.settings = newValue
        }
    }
    open var tintColors: CalendarMonthView.State<UIColor?> {
        get { return self.monthView.tintColors }
        set { self.monthView.tintColors = newValue }
    }
    open var titleColors: CalendarMonthView.State<UIColor?> {
        get { return self.monthView.titleColors }
        set { self.monthView.titleColors = newValue }
    }
    open var titleFonts: CalendarMonthView.State<UIFont> {
        get { return self.monthView.titleFonts }
        set { self.monthView.titleFonts = newValue }
    }
    open var weekHeight: CGFloat = 36.0 {
        didSet { self.updateWeekHeight() }
    }
    open var weekTitleColor: UIColor? {
        get { return self.weekView.titleColor }
        set { self.weekView.titleColor = newValue }
    }
    open var weekTitleFont: UIFont {
        get { return self.weekView.titleFont }
        set { self.weekView.titleFont = newValue }
    }
    open var year: Int {
        get { return self.monthView.year }
        set { self.monthView.year = newValue }
    }

    public var onSelect: (([Date]) -> Void)? {
        get { return self.monthView.onSelect }
        set { self.monthView.onSelect = newValue }
    }

    private (set) var state: FormsComponentStateType = .active

    override open func setupView() {
        self.setupBackgroundView()
        self.setupWeekView()
        self.setupMonthView()
        super.setupView()
    }

    override open func setTheme() {
        super.setTheme()
        self.weekView.setTheme()
        self.monthView.setTheme()
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
    
    open func setupWeekView() {
        self.backgroundView.addSubview(self.weekView, with: [
            Anchor.to(self.backgroundView).top,
            Anchor.to(self.backgroundView).horizontal,
            Anchor.to(self.weekView).height(self.weekHeight)
        ])
    }
    
    open func setupMonthView() {
        self.backgroundView.addSubview(self.monthView, with: [
            Anchor.to(self.weekView).topToBottom,
            Anchor.to(self.backgroundView).horizontal,
            Anchor.to(self.backgroundView).bottom
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
        self.weekView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.weekView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.weekView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.monthView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.monthView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.monthView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updateWeekHeight() {
        self.weekView.constraint(position: .height)?.isActive = false
        self.weekView.anchors([
            Anchor.to(self.weekView).height(self.weekHeight)
        ])
    }
    
    public func remakeContentView() {
        self.weekView.remakeContentView()
        self.monthView.remakeContentView()
    }
}

// MARK: Builder
public extension CalendarMonthWithWeekView {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    @objc
    override func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColors = CalendarMonthView.State<UIColor?>(backgroundColor)
        return self
    }
    func with(backgroundColors: CalendarMonthView.State<UIColor?>) -> Self {
        self.backgroundColors = backgroundColors
        return self
    }
    func with(date: Date?) -> Self {
        self.date = date
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(itemSize: CGFloat) -> Self {
        self.itemSize = itemSize
        return self
    }
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    func with(month: Month) -> Self {
        self.month = month
        return self
    }
    func with(settings: CalendarSettings) -> Self {
        self.settings = settings
        return self
    }
    func with(selectionType: CalendarMonthView.SelectionType) -> Self {
        self.selectionType = selectionType
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColors = CalendarMonthView.State<UIColor?>(tintColor)
        return self
    }
    func with(tintColors: CalendarMonthView.State<UIColor?>) -> Self {
        self.tintColors = tintColors
        return self
    }
    func with(titleColor: UIColor?) -> Self {
        self.titleColors = CalendarMonthView.State<UIColor?>(titleColor)
        return self
    }
    func with(titleColors: CalendarMonthView.State<UIColor?>) -> Self {
        self.titleColors = titleColors
        return self
    }
    func with(titleFont: UIFont) -> Self {
        self.titleFonts = CalendarMonthView.State<UIFont>(titleFont)
        return self
    }
    func with(titleFonts: CalendarMonthView.State<UIFont>) -> Self {
        self.titleFonts = titleFonts
        return self
    }
    func with(weekHeight: CGFloat) -> Self {
        self.weekHeight = weekHeight
        return self
    }
    func with(weekTitleColor: UIColor?) -> Self {
        self.weekTitleColor = weekTitleColor
        return self
    }
    func with(weekTitleFont: UIFont) -> Self {
        self.weekTitleFont = weekTitleFont
        return self
    }
    func with(year: Int) -> Self {
        self.year = year
        return self
    }
}
