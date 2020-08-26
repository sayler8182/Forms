//
//  CalendarWeekView.swift
//  FormsCalendarKit
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import UIKit

// MARK: CalendarWeekItem
private struct CalendarWeekItem {
    let weekday: Weekday
    let title: String
}

// MARK: CalendarWeekView
open class CalendarWeekView: FormsComponent, Clickable, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let contentView = UIStackView()

    open var animationTime: TimeInterval = 0.1
    open var axis: NSLayoutConstraint.Axis {
        get { return self.contentView.axis }
        set { self.contentView.axis = newValue }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var height: CGFloat = 36.0
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var settings: CalendarSettings = CalendarSettings() {
        didSet { self.remakeContentView() }
    }
    open var titleColor: UIColor? = Theme.Colors.primaryDark {
        didSet { self.updateContentView() }
    }
    open var titleFont: UIFont = Theme.Fonts.regular(ofSize: 14) {
        didSet { self.updateContentView() }
    }

    public var onClick: (() -> Void)? = nil

    override open func setupView() {
        self.setupBackgroundView()
        self.setupContentView()
        super.setupView()
    }

    override open func setTheme() {
        super.setTheme()
        self.updateContentView()
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
    
    open func setupContentView() {
        self.contentView.alignment = UIStackView.Alignment.fill
        self.contentView.axis = NSLayoutConstraint.Axis.horizontal
        self.contentView.distribution = UIStackView.Distribution.fillEqually
        self.contentView.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.contentView, with: [
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
        self.contentView.frame = self.backgroundView.bounds.with(inset: edgeInset)
        self.contentView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: View
public extension CalendarWeekView {
    func remakeContentView() {
        guard !self.isBatchUpdateInProgress else { return }
        self.contentView.removeArrangedSubviews()
        let weekday: Weekday = self.settings.weekdayBegin
        let items: [CalendarWeekItem] = self.items(from: weekday)
        for item in items {
            let view: UIView = UIView()
            let label: UILabel = UILabel()
            label.textAlignment = .center
            label.text = item.title
            view.addSubview(label, with: [
                Anchor.to(view).fill
            ])
            self.contentView.addArrangedSubview(view)
        }
        self.updateContentView()
    }
    
    private func updateContentView() {
        self.backgroundView.backgroundColor = self.backgroundColor
        for view in self.contentView.arrangedSubviews {
            let label: UILabel? = view.subviews[safe: 0] as? UILabel
            label?.textColor = self.titleColor
            label?.font = self.titleFont
        }
    }
}

// MARK: Utils
private extension CalendarWeekView {
    func items(from weekday: Weekday) -> [CalendarWeekItem] {
        let weekdays: [Weekday] = self.weekdays(from: weekday)
        let items: [CalendarWeekItem] = weekdays.map {
            CalendarWeekItem(
                weekday: $0,
                title: $0.title(for: self.settings.weekdayFormat))
        }
        return items
    }
    func weekdays(from weekday: Weekday) -> [Weekday] {
        let weekdays: [Weekday] = Weekday.allCases
        let before: [Weekday] = weekdays.filter { $0 < weekday }
        let after: [Weekday] = weekdays.filter { $0 >= weekday }
        return after + before
    }
}

// MARK: Builder
public extension CalendarWeekView {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(settings: CalendarSettings) -> Self {
        self.settings = settings
        return self
    }
    func with(titleColor: UIColor?) -> Self {
        self.titleColor = titleColor
        return self
    }
    func with(titleFont: UIFont) -> Self {
        self.titleFont = titleFont
        return self
    }
}
