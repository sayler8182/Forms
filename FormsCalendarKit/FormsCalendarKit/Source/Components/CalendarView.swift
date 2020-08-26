//
//  CalendarView.swift
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

// MARK: ScrollDirection
public extension CalendarView {
    enum CalendarDirection {
        case horizontal
        case vertical
        
        var scrollDirection: UICollectionView.ScrollDirection {
            switch self {
            case .horizontal: return .horizontal
            case .vertical: return .vertical
            }
        }
    }
}

// MARK: YearItem
private struct YearItem: SelectorItem {
    let rawValue: Int
    let title: String
    
    init(_ year: Int) {
        self.rawValue = year
        self.title = year.description
    }
}

// MARK: CalendarItem
public struct CalendarItem: Equatable {
    let month: Month
    let year: Int
    let rows: Int
}

// MARK: CalendarView
open class CalendarView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let headerView = UIStackView()
    public let yearView = Components.selector.default()
    public let weekView = Components.calendar.week()
    public let contentView = UIView()
    public lazy var collectionView = UICollectionView(
        frame: CGRect(width: 320, height: 40),
        collectionViewLayout: self.flowLayout)

    private lazy var flowLayout = CalendarViewCollectionFlowLayout(
        scrollDirection: self.direction.scrollDirection)
    private let calendarUpdatesQueue: DispatchQueue = DispatchQueue(
        label: "calendarUpdatesQueue",
        target: DispatchQueue.main)
    private let defaultCellIdentifier: String = "_cell"
    private var updateHeightDebouncer: Debouncer = Debouncer(interval: 0.5)
    
    open var animationTime: TimeInterval = 0.1 {
        didSet { self.reloadData() }
    }
    open var backgroundColors = CalendarMonthView.State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.reloadData() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var dateFrom: Date? = nil {
        didSet { self.generateItems() }
    }
    open var date: Date? = nil {
        didSet { self.reloadData() }
    }
    open var dateTo: Date? = nil {
        didSet { self.generateItems() }
    }
    open var dayColors = CalendarMonthView.State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.reloadData() }
    }
    open var dayFonts = CalendarMonthView.State<UIFont>(Theme.Fonts.regular(ofSize: 14)) {
        didSet { self.reloadData() }
    }
    open var direction: CalendarDirection = .vertical {
        didSet { self.flowLayout.scrollDirection = self.direction.scrollDirection }
    }
    open var itemSize: CGFloat = 36.0 {
        didSet {
            self.reloadData()
            self.updateScrollPosition()
        }
    }
    open var isEnabled: Bool = true {
        didSet { self.reloadData() }
    }
    open var isScrollToMonth: Bool = true {
        didSet {
            self.reloadData()
            self.updateScrollPosition()
        }
    }
    open var isWeekVisible: Bool = true {
        didSet {
            self.reloadData()
            self.updateScrollPosition()
        }
    }
    open var isYearVisible: Bool = true {
        didSet {
            self.reloadData()
            self.updateScrollPosition()
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
            self.updateScrollPosition()
        }
    }
    open var monthColor: UIColor? = Theme.Colors.primaryDark {
        didSet { self.reloadData() }
    }
    open var monthSize: CGFloat = 44.0 {
        didSet { self.reloadData() }
    }
    open var monthFont: UIFont = Theme.Fonts.regular(ofSize: 14) {
        didSet { self.reloadData() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    private var _selectedDates: [Date] = []
    open var selectedDates: [Date] {
        get { return self._selectedDates }
        set { self._selectedDates = newValue }
    }
    open var selectionType: CalendarMonthView.SelectionType = .single {
        didSet { self.reloadData() }
    }
    open var settings: CalendarSettings = CalendarSettings() {
        didSet { self.reloadData() }
    }
    open var tintColors = CalendarMonthView.State<UIColor?>(Theme.Colors.tertiaryLight) {
        didSet { self.reloadData() }
    }
    open var weekHeight: CGFloat = 36.0 {
        didSet { self.reloadData() }
    }
    open var weekTitleColor: UIColor? = Theme.Colors.tertiaryDark {
        didSet { self.reloadData() }
    }
    open var weekTitleFont: UIFont = Theme.Fonts.regular(ofSize: 12) {
        didSet { self.reloadData() }
    }
    private var _year: Int = Date().year
    open var year: Int {
        get { return self._year }
        set {
            self._year = newValue
            self.updateScrollPosition()
        }
    }
    
    private var _items: [CalendarItem] = []
    private var items: [CalendarItem] {
        get { return self._items }
        set {
            self._items = newValue
            self.reloadData()
        }
    }
    private var selected: CalendarItem? {
        return self.items.first(where: { $0.year == self.year && $0.month == self.month })
    }
     
    public var onSelect: ((Int, Month) -> Void)? = nil
    public var onSelectDate: (([Date]) -> Void)? = nil
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.updateScrollPosition(animated: false)
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupHeaderView()
        self.setupYearView()
        self.setupWeekView()
        self.setupContentView()
        self.setupCollectionView()
        self.generateItems()
        self.reloadData()
        super.setupView()
    }

    override open func setTheme() {
        super.setTheme()
        self.reloadData()
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
    
    open func setupHeaderView() {
        self.headerView.alignment = UIStackView.Alignment.fill
        self.headerView.axis = NSLayoutConstraint.Axis.vertical
        self.headerView.distribution = UIStackView.Distribution.fill
        self.headerView.spacing = 0
        self.backgroundView.addSubview(self.headerView, with: [
            Anchor.to(self.backgroundView).top,
            Anchor.to(self.backgroundView).horizontal
        ])
    }
    
    open func setupYearView() {
        self.yearView.selected = self.yearView.items.first(where: { $0.rawValue == self.year })
        self.yearView.onValueChanged = Unowned(self) { (_self, item) in
            _self.year = item.rawValue
        }
    }
    
    open func setupWeekView() {
        self.weekView.anchors([
            Anchor.to(self.weekView).height(self.weekHeight)
        ])
    }
    
    open func setupContentView() {
        self.contentView.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.contentView, with: [
            Anchor.to(self.headerView).topToBottom,
            Anchor.to(self.backgroundView).horizontal,
            Anchor.to(self.backgroundView).bottom
        ])
    }
    
    open func setupCollectionView() {
        self.collectionView.frame = self.contentView.bounds
        self.collectionView.clipsToBounds = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.defaultCellIdentifier)
        self.contentView.addSubview(self.collectionView, with: [
            Anchor.to(self.contentView).top,
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.contentView).bottom.priority(.veryHigh),
            Anchor.to(self.collectionView).height(200).greaterThanOrEqual
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
        self.headerView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.headerView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.headerView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func reloadData() {
        guard !self.isBatchUpdateInProgress else { return }
        self.headerView.removeArrangedSubviews()
        self.weekView.backgroundColor = self.backgroundColors.value(for: .active)
        self.weekView.titleColor = self.weekTitleColor
        self.weekView.titleFont = self.weekTitleFont
        self.weekView.settings = settings
        self.weekView.constraint(position: .height)?.isActive = false
        self.weekView.anchors([
            Anchor.to(self.weekView).height(self.weekHeight)
        ])
        if self.isYearVisible {
            self.headerView.addArrangedSubview(self.yearView)
        }
        if self.isWeekVisible {
            self.headerView.addArrangedSubview(self.weekView)
        }
        self.collectionView.backgroundColor = self.backgroundColors.value(for: .active)
        self.calendarUpdatesQueue.async {
            self.collectionView.reloadData()
            self.updateCollectionHeight(animated: false)
        }
    }
    
    private func generateItems() {
        let from: Date = self.dateFrom ?? Date.unixStartDate
        let to: Date = self.dateTo ?? Date()
            .adding(.year, value: 25)
            .end(of: .year)
        let dates: [Date] = Date.date(in: from...to, interval: .month)
        let yearItems: [SelectorItem] = dates
            .map { $0.year }
            .withoutDuplicates
            .map { YearItem($0) }
        let calendarItems: [CalendarItem] = dates
            .map { CalendarItem(month: $0.month, year: $0.year, rows: $0.rowsCount) }
        self.yearView.items = yearItems
        self.items = calendarItems
    }
    
    private func updateCollectionHeight(animated: Bool = true) {
        self.updateHeightDebouncer.debounce(forceNow: !animated) { [weak self] in
            guard let `self` = self else { return }
            self.handleCollectionHeightUpdate(animated: animated)
        }
    }
    
    @objc
    private func handleCollectionHeightUpdate(animated: Bool) {
        guard let item: CalendarItem = self.selected else { return }
        var height: CGFloat = item.rows.asCGFloat * self.itemSize
        height = !self.isScrollToMonth ? height : height + self.monthSize
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                self.collectionView.constraint(position: .height)?.constant = height
                self.table?.refreshTableView(animated: animated)
                self.superview?.layoutIfAnimated(animated: animated)
        })
    }
}

// MARK: Scroll
public extension CalendarView {
    func updateScrollPosition(animated: Bool = true) {
        guard let item: CalendarItem = self.selected else { return }
        self.scrollTo(item: item, animated: animated, notify: false)
    }
    
    func scrollTo(item: CalendarItem?,
                  animated: Bool,
                  notify: Bool = true) {
        guard let item: CalendarItem = item else { return }
        self._month = item.month
        self._year = item.year
        self.updateCollectionHeight()
        self.calendarUpdatesQueue.async {
            guard var offset: CGPoint = self.offsetForItem(item) else { return }
            offset = self.isScrollToMonth ? offset : offset + CGPoint(x: 0, y: self.monthSize)
            guard self.collectionView.contentOffset != offset else { return }
            self.collectionView.setContentOffset(offset, animated: animated)
        }
        if notify {
            self.onSelect?(item.year, item.month)
        }
        let yearItem: YearItem = YearItem(item.year)
        guard self.yearView.selected?.rawValue != item.year else { return }
        self.yearView.scrollTo(item: yearItem, animated: animated, notify: false)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, CalendarViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, CalendarViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 
        return self.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.defaultCellIdentifier, for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let contentView: UIView = cell.subviews.first else { return }
        contentView.clipsToBounds = true
        let item: CalendarItem = self.items[indexPath.row]
        let label: UILabel = (contentView.subviews[safe: 0] as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.text = item.month.title(for: "MMMM") + " " + item.year.description
        label.textColor = self.monthColor
        label.font = self.monthFont
        if label.superview.isNil {
            contentView.addSubview(label, with: [
                Anchor.to(contentView).top,
                Anchor.to(contentView).horizontal,
                Anchor.to(label).height(self.monthSize)
            ])
        }
        let monthView: CalendarMonthView = (contentView.subviews[safe: 1] as? CalendarMonthView) ?? Components.calendar.month()
        monthView.batchUpdate({
            monthView.animationTime = self.animationTime
            monthView.backgroundColors = self.backgroundColors
            monthView.date = self.date
            monthView.itemSize = self.itemSize
            monthView.isEnabled = self.isEnabled
            monthView.month = item.month
            monthView.selectedDates = self.selectedDates
            monthView.settings = self.settings
            monthView.tintColors = self.tintColors
            monthView.titleColors = self.dayColors
            monthView.titleFonts = self.dayFonts
            monthView.year = item.year
            monthView.onSelect = Unowned(self) { (_self, dates) in
                _self.selectedDates = dates
                _self.onSelectDate?(dates)
            }
        }, monthView.remakeContentView)
        if monthView.superview.isNil {
            contentView.addSubview(monthView, with: [
                Anchor.to(label).topToBottom,
                Anchor.to(contentView).horizontal,
                Anchor.to(monthView).height(item.rows.asCGFloat * self.itemSize)
            ])
        }
        cell.layoutWithoutAnimation()
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat? {
        let item: CalendarItem = self.items[indexPath.row]
        return item.rows.asCGFloat * self.itemSize + self.monthSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat? {
        let item: CalendarItem = self.items[indexPath.row]
        return item.rows.asCGFloat * self.itemSize + self.monthSize
    }
}

// MARK: UIScrollViewDelegate
extension CalendarView {
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        let now: Date = Date()
        guard let item = self.items.first(where: { $0.year == now.year && $0.month == now.month }) else { return true }
        self.scrollTo(item: item, animated: true)
        return false
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.updateHeightDebouncer.invalidate()
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let item: CalendarItem = self.itemForOffset(targetContentOffset.pointee) else { return }
        scrollView.targetContentOffset = self.offsetForItem(item)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let item: CalendarItem = self.itemForOffset(scrollView.targetContentOffset) else { return }
        self.scrollTo(item: item, animated: true)
    } 
     
    private func itemForOffset(_ offset: CGPoint) -> CalendarItem? {
        guard let layout = self.collectionView.collectionViewLayout as? CalendarViewCollectionFlowLayout else { return nil }
        guard let index: Int = layout.itemForOffset(offset)?.match(in: 0..<(self.items.count - 1)) else { return nil }
        return self.items[safe: index]
    }
    
    private func offsetForItem(_ item: CalendarItem) -> CGPoint? {
        guard let layout = self.collectionView.collectionViewLayout as? CalendarViewCollectionFlowLayout else { return nil }
        guard let index = self.items.firstIndex(where: { $0 == item }) else { return nil }
        return layout.offsetForIndex(index)
    }
}

// MARK: CalendarViewDelegateFlowLayout
public protocol CalendarViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat?
}

// MARK: CalendarViewCollectionFlowLayout
open class CalendarViewCollectionFlowLayout: UICollectionViewFlowLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = CGSize()
    
    override open var scrollDirection: UICollectionView.ScrollDirection {
        get { return super.scrollDirection }
        set { // swiftlint:disable:this unused_setter_value
            super.scrollDirection = .vertical // supports only horizontal
            self.invalidateLayout()
        }
    }
    
    public var itemWidth: CGFloat {
        return self.collectionView?.frame.width.floored ?? 0.0
    }
    
    public var itemHeight: CGFloat {
        return self.collectionView?.frame.height.floored ?? 0.0
    }
    
    public init(scrollDirection: UICollectionView.ScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollDirection = .horizontal
    }
    
    override public var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        switch self.scrollDirection {
        case .vertical:
            guard self.collectionView?.bounds.width != newBounds.width else { return false }
            self.cache = []
        case .horizontal:
            guard self.collectionView?.bounds.height != newBounds.height else { return false }
            self.cache = []
        @unknown default: break
        }
        return true
    }
    
    override public func prepare() {
        self.itemSize = CGSize(width: 320, height: 40)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        super.prepare()
        guard self.cache.isEmpty else { return }
        guard let collectionView = self.collectionView else { return }
        guard let delegate = collectionView.delegate as? CalendarViewDelegateFlowLayout else { return }
        switch self.scrollDirection {
        case .vertical: self.prepareVertical(collectionView: collectionView, delegate: delegate)
        case .horizontal: self.prepareHorizontal(collectionView: collectionView, delegate: delegate)
        @unknown default: break
        }
    }
    
    private func prepareVertical(collectionView: UICollectionView,
                                 delegate: CalendarViewDelegateFlowLayout) {
        let width: CGFloat = self.itemWidth
        let contentInset: UIEdgeInsets = UIEdgeInsets(0)
        let offsetsX: CGFloat = contentInset.leading
        var offsetsY: CGFloat = contentInset.top
        let itemsCount: Int = collectionView.numberOfItems(inSection: 0)
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let height: CGFloat = delegate.collectionView(collectionView, heightForItemAt: indexPath) ?? 0
            let frame: CGRect = CGRect(x: offsetsX, y: offsetsY, width: width, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            offsetsY += height
        }
        self.contentSize = CGSize(
            width: collectionView.frame.width,
            height: offsetsY + contentInset.bottom)
    }
    
    private func prepareHorizontal(collectionView: UICollectionView,
                                   delegate: CalendarViewDelegateFlowLayout) {
        let height: CGFloat = self.itemHeight
        let contentInset: UIEdgeInsets = UIEdgeInsets(0)
        var offsetsX: CGFloat = contentInset.leading
        let offsetsY: CGFloat = contentInset.top
        let itemsCount: Int = collectionView.numberOfItems(inSection: 0)
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let width: CGFloat = delegate.collectionView(collectionView, widthForItemAt: indexPath) ?? 0
            let frame: CGRect = CGRect(x: offsetsX, y: offsetsY, width: width, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            offsetsX += width
        }
        self.contentSize = CGSize(
            width: offsetsX + contentInset.trailing,
            height: collectionView.frame.height)
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    public func itemForOffset(_ offset: CGPoint) -> Int? {
        switch self.scrollDirection {
        case .vertical:
            for (i, attributes) in self.cache.enumerated() {
                guard attributes.center.y > offset.y else { continue }
                return i
            }
            return nil
        case .horizontal:
            for (i, attributes) in self.cache.enumerated() {
                guard attributes.center.x > offset.x else { continue }
                return i
            }
            return nil
        @unknown default:
            return nil
        }
    }
    
    public func offsetForIndex(_ index: Int) -> CGPoint? {
        return self.cache[safe: index]?.frame.origin
    }
}

// MARK: Builder
public extension CalendarView {
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
    func with(direction: CalendarDirection) -> Self {
        self.direction = direction
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
    func with(isScrollToMonth: Bool) -> Self {
        self.isScrollToMonth = isScrollToMonth
        return self
    }
    func with(isWeekVisible: Bool) -> Self {
        self.isWeekVisible = isWeekVisible
        return self
    }
    func with(isYearVisible: Bool) -> Self {
        self.isYearVisible = isYearVisible
        return self
    }
    func with(month: Month) -> Self {
        self.month = month
        return self
    }
    func with(monthColor: UIColor?) -> Self {
        self.monthColor = monthColor
        return self
    }
    func with(monthSize: CGFloat) -> Self {
        self.monthSize = monthSize
        return self
    }
    func with(monthFont: UIFont) -> Self {
        self.monthFont = monthFont
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
