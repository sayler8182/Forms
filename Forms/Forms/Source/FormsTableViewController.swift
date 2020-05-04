//
//  FormsTableViewController.swift
//  Forms
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit
import Validators

// MARK: TableProtocol
public protocol TableProtocol: class {
    func refreshTableView()
    func refreshTableView(animated: Bool)
}

// MARK: FormsTableViewController
open class FormsTableViewController: FormsViewController, UITableViewDelegate, UITableViewDataSource, TableDataSourceDelegateProtocol, TableProtocol {
    private let tableUpdatesQueue: DispatchQueue = DispatchQueue(
        label: "tableUpdatesQueue",
        target: DispatchQueue.main)
    private let headerView: UIView = UIView(width: 320, height: 44)
    private let footerView: UIStackView = UIStackView()
    private let defaultCellIdentifier: String = "_cell"
    
    public private (set) var views: [FormsComponent] = []
    private let tableView: UITableView = UITableView(
        frame: CGRect(width: 320, height: 44),
        style: .plain)
    private var refreshControl: UIRefreshControl? = nil
    private var shimmerDataSource: ShimmerTableDataSource? = nil
    
    open var cellBackgroundColor: UIColor = UIColor.systemBackground {
        didSet { self.tableView.reloadData() }
    }
    open var footerBackgroundColor: UIColor = UIColor.systemBackground {
        didSet { self.footerView.backgroundColor = self.footerBackgroundColor }
    }
    open var footerSpacing: CGFloat = 8 {
        didSet { self.footerView.spacing = self.footerSpacing }
    }
    open var headerBackgroundColor: UIColor = UIColor.systemBackground {
        didSet { self.headerView.backgroundColor = self.headerBackgroundColor }
    }
    open var isBottomToSafeArea: Bool = true
    open var isTopToSafeArea: Bool = true
    open var paginationDelayExpiration: TimeInterval = 0
    open var paginationIsAutostart: Bool = true
    open var paginationIsLoading: Bool = false
    open var paginationIsEnabled: Bool = false
    open var paginationIsFinished: Bool = false
    open var paginationOffset: CGFloat = 0
    open var pullToRefreshIsLoading: Bool = false
    open var pullToRefreshIsEnabled: Bool = false
    open var tableAllowsSelection: Bool = false {
        didSet { self.tableView.allowsSelection = self.tableAllowsSelection }
    }
    open var tableAlwaysBounceVertical: Bool = false {
        didSet { self.tableView.alwaysBounceVertical = self.tableAlwaysBounceVertical }
    }
    open var tableBackgroundColor: UIColor = UIColor.clear {
        didSet { self.tableView.backgroundColor = self.tableBackgroundColor }
    }
    open var tableContentInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.tableView.contentInset = self.tableContentInset }
    }
    open var tableEstimatedRowHeight: CGFloat = 44.0 {
        didSet { self.tableView.estimatedRowHeight = self.tableEstimatedRowHeight }
    }
    open var tableRowHeight: CGFloat = UITableView.automaticDimension {
        didSet { self.tableView.rowHeight = self.tableRowHeight }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.updateHeaderViewHeight()
    }
    
    override open func setupView() {
        super.setupView()
        self.setupHeaderView()
        self.setupTableView()
        self.setupDataSource()
        self.setupFooterView()
        
        // HOOKS
        self.setupHeader()   
        self.setupFooter()
        self.setupPagination()
        self.setupPullToRefresh()
    }
     
    override public func startShimmering(animated: Bool = true) {
        let shimmerDataSource = ShimmerTableDataSource()
            .with(generators: [ShimmerRowGenerator(type: ShimmerTableViewCell.self, count: 20)])
        self.startShimmering(
            shimmerDataSource,
            animated: animated)
    }
    
    public func startShimmering(_ shimmerDataSource: ShimmerTableDataSource,
                                animated: Bool = true) {
        shimmerDataSource.prepare(
            for: self.tableView,
            queue: self.tableUpdatesQueue,
            scrollDelegate: self)
        shimmerDataSource.prepareGenerators()
        self.shimmerDataSource = shimmerDataSource
        self.setDataSource(
            delegate: shimmerDataSource,
            dataSource: shimmerDataSource)
    }
    
    override public func stopShimmering(animated: Bool = true) {
        self.shimmerDataSource?.stopShimmering(animated: animated)
    }
    
    public func stopShimmering(newDataSource: TableDataSource?,
                               animated: Bool = true) {
        self.shimmerDataSource?.stopShimmering(animated: animated)
        self.shimmerDataSource = nil
        newDataSource?.prepare(
            for: self.tableView,
            queue: self.tableUpdatesQueue,
            scrollDelegate: self)
        self.setDataSource(
            delegate: newDataSource,
            dataSource: newDataSource)
    }
    
    public func build(_ components: [FormsComponent?],
                      divider: Divider) {
        let components: [FormsComponent] = components.compactMap { $0 }
        var _components: [FormsComponent] = []
        for (i, component) in components.enumerated() {
            _components.append(component)
            if i < components.count - 1 {
                _components.append(divider)
            }
        }
        self.build(_components)
    }
    
    public func build(_ components: [FormsComponent?]) {
        let components: [FormsComponent] = components.compactMap { $0 }
        self.tableUpdatesQueue.async {
            components.forEach { $0.table = self }
            self.views = components
            self.tableView.reloadData()
        }
    }
    
    private func setupHeaderView() {
        self.headerView.backgroundColor = self.headerBackgroundColor
        let layoutGuide: LayoutGuide = self.isTopToSafeArea ? .safeArea : .normal
        let offset: CGFloat = self.isTopToSafeArea ? self.additionalTopSafeArea : 0
        self.view.addSubview(self.headerView, with: [
            Anchor.to(self.view).top.layoutGuide(layoutGuide).offset(offset),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.headerView).height(0.0).lowPriority
        ])
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableEstimatedRowHeight
        self.tableView.rowHeight = self.tableRowHeight
        self.tableView.backgroundColor = self.tableBackgroundColor
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = self.tableAllowsSelection
        self.tableView.alwaysBounceVertical = self.tableAlwaysBounceVertical
        self.tableView.contentInset = self.tableContentInset
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.tableView, with: [
            Anchor.to(self.headerView).topToBottom,
            Anchor.to(self.view).horizontal
        ])
    }
    
    private func setupFooterView() {
        self.footerView.backgroundColor = self.footerBackgroundColor
        self.footerView.alignment = UIStackView.Alignment.fill
        self.footerView.axis = NSLayoutConstraint.Axis.vertical
        self.footerView.distribution = UIStackView.Distribution.equalSpacing
        self.footerView.spacing = self.footerSpacing
        let layoutGuide: LayoutGuide = self.isBottomToSafeArea ? .safeArea : .normal
        self.view.addSubview(self.footerView, with: [
            Anchor.to(self.tableView).topToBottom,
            Anchor.to(self.view).bottom.layoutGuide(layoutGuide).connect(self.bottomAnchor),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.footerView).height(0.0).lowPriority
        ])
    }
    
    public func setSeparator(_ style: SeparatorStyle) {
        for view in self.views {
            view.setSeparator(style)
        }
    }
    
    // MARK: HOOKS 
    open func setupHeader() {
        // HOOK
    }
    
    open func setupDataSource() {
        // HOOK
    }
    
    open func setupFooter() {
        // HOOK
    }
    
    open func setupCell(row: TableRow,
                        cell: FormsTableViewCell,
                        indexPath: IndexPath) {
        // HOOK
    }
    
    open func selectCell(row: TableRow,
                         cell: FormsTableViewCell,
                         indexPath: IndexPath) {
        // HOOK
    }
    
    open func setupPagination() {
        guard self.paginationIsAutostart else { return }
        self.paginationRaise()
        // HOOK
    }
    
    open func paginationNext() {
        // HOOK
    }
    
    open func setupPullToRefresh() {
        guard self.pullToRefreshIsEnabled else { return }
        self.setPullToRefresh()
        // HOOK
    }
    
    open func pullToRefresh() {
        // HOOK
    }
    
    override open func updateSafeArea() {
        super.updateSafeArea()
        self.headerView.constraint(to: self.view, position: .top, layoutGuide: .safeArea)?.constant = self.additionalTopSafeArea
        // HOOK
    }
}

// MARK: Header
public extension FormsTableViewController {
    func setHeader(_ view: UIView,
                   height: CGFloat? = nil) {
        self.headerView.subviews.removeFromSuperview()
        if let height: CGFloat = height {
            self.headerView.addSubview(view, with: [
                Anchor.to(self.headerView).fill,
                Anchor.to(view).height(height)
            ])
        } else {
            self.headerView.addSubview(view, with: [
                Anchor.to(self.headerView).fill
            ])
        }
    }
}

// MARK: Components
public extension FormsTableViewController {
    func add(_ components: [FormsComponent],
             animated: UITableView.RowAnimation = .automatic) {
        for component in components {
            self.add(component, animated: animated)
        }
    }
    
    func add(_ component: FormsComponent,
             animated: UITableView.RowAnimation = .automatic) {
        let index: Int = self.views.count
        self.insert(component, at: index, animated: animated)
    }
    
    func insert(_ component: FormsComponent,
                after: FormsComponent,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: after) else { return }
        self.insert(component, at: index + 1, animated: animated)
    }
    
    func insert(_ components: [FormsComponent],
                after: FormsComponent,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: after) else { return }
        self.insert(components, at: index, animated: animated)
    }
    
    func insert(_ component: FormsComponent,
                before: FormsComponent,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: before) else { return }
        self.insert(component, at: index, animated: animated)
    }
    
    func insert(_ components: [FormsComponent],
                before: FormsComponent,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: before) else { return }
        self.insert(components, at: index, animated: animated)
    }
    
    func insert(_ components: [FormsComponent],
                at index: Int,
                animated: UITableView.RowAnimation = .automatic) {
        for (i, component) in components.enumerated() {
            self.insert(component, at: index + i, animated: animated)
        }
    }
    
    func insert(_ component: FormsComponent,
                at index: Int,
                animated animation: UITableView.RowAnimation = .automatic) {
        self.tableUpdatesQueue.async {
            self.views.insert(component, at: index)
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            self.tableView.animated(animation) {
                self.tableView.insertRows(at: [indexPath], with: animation)
            }
        }
    }
    
    func remove(_ components: [FormsComponent],
                animated: UITableView.RowAnimation = .automatic) {
        for component in components {
            self.remove(component, animated: animated)
        }
    }
    
    func remove(_ component: FormsComponent,
                animated animation: UITableView.RowAnimation = .automatic) {
        self.tableUpdatesQueue.async {
            guard let index: Int = self.views.firstIndex(of: component) else { return }
            self.views.remove(at: index)
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            self.tableView.animated(animation) {
                self.tableView.deleteRows(at: [indexPath], with: animation)
            }
        }
    }
}

// MARK: Footer
public extension FormsTableViewController {
    func addToFooter(_ views: [UIView],
                     height: CGFloat? = nil) {
        for view in views {
            self.addToFooter(view, height: height)
        }
    }
    
    func addToFooter(_ view: UIView,
                     height: CGFloat? = nil) {
        let index: Int = self.footerView.arrangedSubviews.count
        self.insertToFooter(view, at: index, height: height)
    }
    
    func insertToFooter(_ views: [UIView],
                        at index: Int,
                        height: CGFloat? = nil) {
        for view in views {
            self.insertToFooter(view, at: index, height: height)
        }
    }
    
    func insertToFooter(_ view: UIView,
                        at index: Int,
                        height: CGFloat? = nil) {
        if let height: CGFloat = height {
            self.footerView.insertArrangedSubview(view, at: index, with: [
                Anchor.to(view).height(height)
            ])
        } else {
            self.footerView.insertArrangedSubview(view, at: index) 
        }
    }
    
    func removeFromFooter(_ views: [UIView]) {
        for view in views {
            self.removeFromFooter(view)
        }
    }
    
    func removeFromFooter(_ view: UIView) {
        self.footerView.removeArrangedSubview(view)
    }
}

// MARK: Validators
public extension FormsTableViewController {
    @discardableResult
    func validate() -> Bool {
        var result: Bool = true
        let items: [Validable] = self.views.compactMap { $0 as? Validable }
        for item in items {
            result = item.validate()
            guard result else { break }
        }
        self.refreshTableView()
        return result
    }
}

// MARK: TableView
public extension FormsTableViewController {
    func reloadData(animated: Bool = true) {
        self.tableUpdatesQueue.async {
            self.tableView.transition(
                animated,
                duration: 0.3,
                animations: self.tableView.reloadData)
        }
    }
        
    func updateTableView(animated: Bool = true,
                         update: (() -> Void)? = nil) {
        self.tableUpdatesQueue.async {
            self.tableView.shouldAnimate(animated) {
                self.tableView.performBatchUpdates({
                    update?()
                })
            }
        }
    }
    
    func refreshTableView() {
        self.refreshTableView(animated: true)
    }
    
    func refreshTableView(animated: Bool) {
        self.tableUpdatesQueue.async {
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            self.tableView.shouldAnimate(animated) {
                self.tableView.performBatchUpdates({})
            }
        }
    }
    
    func setDataSource(_ dataSource: TableDataSource?) {
        dataSource?.prepare(
            for: self.tableView,
            queue: self.tableUpdatesQueue,
            scrollDelegate: self)
        self.setDataSource(
            delegate: dataSource,
            dataSource: dataSource)
    }
    
    func setDataSource(delegate: UITableViewDelegate?,
                       dataSource: UITableViewDataSource?) {
        self.tableUpdatesQueue.async {
            self.tableView.delegate = delegate ?? self
            self.tableView.dataSource = dataSource ?? self
        }
    }
}

// MARK: Pagination
public extension FormsTableViewController {
    func paginationSuccess(delay: TimeInterval = 0.5,
                           isLast: Bool = false) {
        self.paginationIsLoading = false
        self.paginationIsFinished = isLast
        self.paginationDelayExpiration = Date().timeIntervalSince1970 + delay
    }
    
    func paginationError(delay: TimeInterval = 5.0,
                         isLast: Bool = false) {
        self.paginationIsLoading = false
        self.paginationIsFinished = isLast
        self.paginationDelayExpiration = Date().timeIntervalSince1970 + delay
    }
    
    private func paginationShouldLoadNext(_ scrollView: UIScrollView) -> Bool {
        return scrollView.shouldLoadNext(offset: self.paginationOffset)
    }
    
    private func paginationRaise() {
        guard self.paginationIsEnabled else { return }
        guard !self.paginationIsFinished else { return }
        guard !self.paginationIsLoading else { return }
        guard !self.pullToRefreshIsLoading else { return }
        guard self.paginationDelayExpiration < Date().timeIntervalSince1970 else { return }
        guard self.paginationShouldLoadNext(self.tableView) else { return }
        self.paginationIsLoading = true
        self.paginationNext()
    }
}

// MARK: PullToRefresh
public extension FormsTableViewController {
    func setPullToRefresh(_ view: UIView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addSubview(view)
        self.refreshControl = refreshControl
        self.pullToRefreshConfigure(refreshControl)
        self.tableView.refreshControl = refreshControl
    }
    
    func setPullToRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
        self.pullToRefreshConfigure(refreshControl)
        self.tableView.refreshControl = refreshControl
    }
    
    func setPullToRefresh() {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        self.pullToRefreshConfigure(refreshControl)
        self.tableView.refreshControl = refreshControl
    }
    
    func pullToRefreshFinish() {
        self.refreshControl?.endRefreshing()
        self.pullToRefreshIsLoading = false
    }
    
    private func pullToRefreshConfigure(_ refreshControl: UIRefreshControl) {
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    @objc
    private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        self.pullToRefreshIsLoading = true
        DispatchQueue.main.async {
            guard !self.paginationIsLoading else {
                self.pullToRefreshIsLoading = false
                return refreshControl.endRefreshing()
            }
            self.tableView.panGestureRecognizer.isEnabled = false
            self.tableView.panGestureRecognizer.isEnabled = true
            self.pullToRefresh()
        }
        // HOOK
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
public extension FormsTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.views.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = self.cellBackgroundColor
        cell.contentView.subviews.removeFromSuperview()
        let view: FormsComponent = self.views[indexPath.row]
        cell.contentView.addSubview(view, with: [
            Anchor.to(cell.contentView).fill
        ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let view: FormsComponent = self.views[indexPath.row]
        return view.componentHeight()
    }
}

// MARK: UIScrollViewDelegate
public extension FormsTableViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.paginationRaise()
    }
}
    
// MARK: Scroll
public extension FormsTableViewController {
    func scroll(to component: FormsComponent,
                at position: UITableView.ScrollPosition = UITableView.ScrollPosition.middle,
                animated: Bool = true) {
        guard let index: Int = self.views.firstIndex(of: component) else { return }
        self.scroll(to: index, at: position, animated: animated)
    }
    
    func scroll(to index: Int,
                at position: UITableView.ScrollPosition = UITableView.ScrollPosition.middle,
                animated: Bool = true) {
        self.tableUpdatesQueue.async {
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: position, animated: animated)
        }
    }
}

// MARK: Inputs
extension FormsTableViewController { }
