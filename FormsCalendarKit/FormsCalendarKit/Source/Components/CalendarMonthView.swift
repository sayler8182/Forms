//
//  CalendarMonthView.swift
//  FormsCalendarKit
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: State
public extension CalendarMonthView {
    struct State<T>: FormsComponentStateActiveSelectedDisabledDisabledSelected {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var disabledSelected: T!
        
        public init() { }
    }
}

// MARK: SelectionType
public extension CalendarMonthView {
    enum SelectionType {
        case none
        case single
        case multiple
        case range
    }
}

// MARK: CalendarMonthView
open class CalendarMonthView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let contentView = UIView()
    
    open var animationTime: TimeInterval = 0.1
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    private var _date: Date? = nil
    open var date: Date? {
        get { return self._date }
        set {
            self._date = newValue
            self.updateState()
        }
    }
    open var itemSize: CGFloat = 36.0 {
        didSet { self.remakeContentView() }
    }
    open var isEnabled: Bool {
        get { return self.isUserInteractionEnabled }
        set {
            newValue ? self.enable(animated: false) : self.disable(animated: false)
            self.updateState()
        }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    private var _month: Month = Date().month
    open var month: Month {
        get { return self._month }
        set {
            self._month = newValue
            self.remakeContentView()
        }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    private var _selectedDates: [Date] = []
    open var selectedDates: [Date] {
        get { return self._selectedDates }
        set {
            self._selectedDates = newValue
            self.updateState()
        }
    }
    open var selectionType: SelectionType = .range {
        didSet { self.updateState() }
    }
    open var settings: CalendarSettings = CalendarSettings() {
        didSet { self.remakeContentView() }
    }
    open var tintColors: State<UIColor?> = State<UIColor?>(Theme.Colors.tertiaryLight) {
        didSet { self.updateState() }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 14)) {
        didSet { self.updateState() }
    }
    private var _year: Int = Date().year
    open var year: Int {
        get { return self._year }
        set {
            self._year = newValue
            self.remakeContentView()
        }
    }
    
    open var targetHeight: CGFloat {
        guard let gridView: GridView = self.contentView.subviews[safe: 0] as? GridView else { return 0.0 }
        return self.itemSize * gridView.sectionsCount.asCGFloat
    }
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: 320, height: self.targetHeight)
    }
    
    public var onSelect: (([Date]) -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = .active
    
    override open func setupView() {
        self.setupComponentView()
        self.setupBackgroundView()
        self.setupContentView()
        self.updateState()
        super.setupView()
    }
    
    override open func setTheme() {
        super.setTheme()
        self.updateContentView()
    }
    
    override open func enable(animated: Bool) {
        if !self.isEnabled {
            self.isEnabled = true
        }
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        if self.isEnabled {
            self.isEnabled = false
        }
        self.setState(.disabled, animated: animated)
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    open func setupComponentView() {
        self.anchors([
            Anchor.to(self).height(self.minHeight).greaterThanOrEqual
        ])
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupContentView() {
        self.contentView.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.contentView, with: [
            Anchor.to(self.backgroundView).top,
            Anchor.to(self.backgroundView).horizontal,
            Anchor.to(self.backgroundView).bottom.priority(.defaultLow)
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
        self.contentView.frame = self.backgroundView.bounds.with(inset: edgeInset)
        self.contentView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    } 
    
    override public func updateState() {
        guard !self.isBatchUpdateInProgress else { return }
        self.setState(self.state, animated: false, force: true)
    }
    
    public func setState(_ state: FormsComponentStateType,
                         animated: Bool,
                         force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.setStateAnimation(state)
        }
        self.state = state
    }
    
    open func setStateAnimation(_ state: FormsComponentStateType) {
        self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
        self.updateContentView()
    }
}

// MARK: View
public extension CalendarMonthView {
    func remakeContentView() {
        guard !self.isBatchUpdateInProgress else { return }
        self.contentView.removeSubviews()
        let view: GridView = GridView()
        view.batchUpdate({
            view.axis = .vertical
            view.items = self.items(
                year: self.year,
                month: self.month)
            view.itemsPerSection = 7
        }, view.remakeView)
        let sectionsCount: Int = view.sectionsCount
        self.contentView.addSubview(view, with: [
            Anchor.to(self.contentView).fill,
            Anchor.to(self.contentView).height(self.itemSize * sectionsCount.asCGFloat)
        ])
    }
    
    private func updateContentView() {
        guard let gridView: GridView = self.contentView.subviews[safe: 0] as? GridView else { return }
        for view in gridView.items {
            self.updateItemView(view: view)
            self.updateSelectedItemView(view: view)
        }
    }
    
    private func items(year: Int,
                       month: Month) -> [UIView] {
        let date: Date = Date([
            .year: year,
            .month: month.order
        ])
        let begin: Date = date.begin(of: .month)
        let end: Date = date.end(of: .month)
        let datesBefore: [Date] = Date.date(
            from: begin.adding(.day, value: -(begin.weekday.order - 1)),
            to: begin.adding(.day, value: -1))
        let dates: [Date] = Date.date(in: begin..<end)
        let datesEnd: [Date] = Date.date(
            from: end,
            to: end.adding(.day, value: 7 - end.weekday.order))
        let views: [UIView] = (datesBefore + dates + datesEnd)
            .map { self.itemView(date: $0, year: year, month: month) }
        return views
    }
    
    private func itemView(date: Date,
                          year: Int,
                          month: Month) -> UIView {
        let view: ResizeableView = ResizeableView()
        view.tag = date.timeIntervalSince1970.asInt
        view.isUserInteractionEnabled = true
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.text = date.day.description
        view.addSubview(label, with: [
            Anchor.to(view).fill
        ])
        self.updateItemView(view: view)
        self.updateSelectedItemView(view: view)
        view.onResize = Unowned(self) { (_self, _) in
            _self.updateSelectedItemView(view: view)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleItemGesture))
        view.addGestureRecognizer(gesture)
        return view
    }
    
    private func itemState(date: Date) -> FormsComponentStateType {
        let isSelected: Bool = date.compare(self.date, to: .day) == .orderedSame
        if date.year == self.year && date.month == self.month && !isSelected {
            return .active
        } else if date.year == self.year && date.month == self.month && isSelected {
            return .selected
        } else if (date.year == self.year || date.month != self.month) && !isSelected {
            return .disabled
        } else {
            return .disabledSelected
        }
    }
    
    private func updateItemView(view: UIView) {
        let label: UILabel? = view.subviews[safe: 0] as? UILabel
        guard view.tag != 0 else { return }
        let date: Date = Date(timeIntervalSince1970: view.tag.asDouble)
        let state: FormsComponentStateType = self.itemState(date: date)
        label?.textColor = self.titleColors.value(for: state)
        label?.font = self.titleFonts.value(for: state)
    }
    
    private func updateSelectedItemView(view: UIView) {
        guard view.tag != 0 else { return }
        let date: Date = Date(timeIntervalSince1970: view.tag.asDouble)
        let state: FormsComponentStateType = self.itemState(date: date)
        let isPrev: Bool = self.selectedDates.contains(date.adding(.day, value: -1))
        let isCurrent: Bool = self.selectedDates.contains(date)
        let isNext: Bool = self.selectedDates.contains(date.adding(.day, value: 1))
        if isCurrent {
            view.backgroundColor = self.tintColors.value(for: .active)
            if isPrev && isNext {
                view.setCornerRadius(radius: 0)
            } else if isPrev {
                view.setCornerRadius(corners: [.topRight, .bottomRight], radius: view.bounds.height / 2)
            } else if isNext {
                view.setCornerRadius(corners: [.topLeft, .bottomLeft], radius: view.bounds.height / 2)
            } else {
                view.setCornerRadius(corners: .allCorners, radius: view.bounds.height / 2)
            }
        } else {
            view.setCornerRadius(radius: 0)
            view.backgroundColor = self.backgroundColors.value(for: state)
        }
    }
    
    @objc
    private func handleItemGesture(recognizer: UIGestureRecognizer) {
        guard let view: UIView = recognizer.view else { return }
        guard view.tag != 0 else { return }
        let date: Date = Date(timeIntervalSince1970: view.tag.asDouble)
        switch self.selectionType {
        case .none: break
        case .single:
            if self.selectedDates.count == 1,
                let selectedDate: Date = self.selectedDates.first {
                self._selectedDates = selectedDate.compare(date) == .orderedSame ? [] : [date]
            } else {
                self._selectedDates = [date]
            }
        case .multiple:
            if self.selectedDates.contains(where: { $0 == date }) {
                self._selectedDates.removeAll(where: { $0 == date })
            } else {
                self._selectedDates.append(date)
            }
        case .range:
            if self.selectedDates.count == 1,
                let selectedDate: Date = self.selectedDates.first {
                if selectedDate.compare(date) == .orderedSame {
                    self._selectedDates = []
                } else {
                    let from: Date = selectedDate.compare(date) == .orderedDescending ? date : selectedDate
                    let to: Date = selectedDate.compare(date) == .orderedAscending ? date : selectedDate
                    self._selectedDates = Date.date(in: from...to)
                }
            } else {
                self._selectedDates = [date]
            }
        }
        self.onSelect?(self.selectedDates)
        self.updateContentView()
    }
}

// MARK: Builder
public extension CalendarMonthView {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    @objc
    override func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColors = State<UIColor?>(backgroundColor)
        return self
    }
    func with(backgroundColors: State<UIColor?>) -> Self {
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
    func with(selectedDates: [Date]) -> Self {
        self.selectedDates = selectedDates
        return self
    }
    func with(selectionType: SelectionType) -> Self {
        self.selectionType = selectionType
        return self
    }
    func with(settings: CalendarSettings) -> Self {
        self.settings = settings
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColors = State<UIColor?>(tintColor)
        return self
    }
    func with(tintColors: State<UIColor?>) -> Self {
        self.tintColors = tintColors
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
    func with(year: Int) -> Self {
        self.year = year
        return self
    }
}
