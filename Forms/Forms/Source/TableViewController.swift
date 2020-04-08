//
//  TableViewController.swift
//  Forms
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TableProtocol
public protocol TableProtocol: class {
    func refreshTableView()
    func refreshTableView(animated animate: Bool)
}

// MARK: TableViewController
open class TableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, TableProtocol {
    private let tableUpdatesQueue: DispatchQueue = DispatchQueue(
        label: "tableUpdatesQueue",
        target: DispatchQueue.main)
    private let headerView: UIView = UIView(width: 320, height: 44)
    private let footerView: UIStackView = UIStackView()
    private let defaultCellIdentifier: String = "cell"
    
    private var views: [Component] = []
    private let tableView: UITableView = UITableView(
        frame: CGRect(width: 320, height: 44),
        style: .plain)
    
    open var headerBackgroundColor: UIColor = UIColor.white {
        didSet { self.headerView.backgroundColor = self.headerBackgroundColor }
    }
    open var tableAlwaysBounceVertical: Bool = false {
        didSet { self.tableView.alwaysBounceVertical = self.tableAlwaysBounceVertical }
    }
    open var tableBackgroundColor: UIColor = UIColor.clear {
        didSet { self.tableView.backgroundColor = self.tableBackgroundColor }
    }
    open var tableEstimatedRowHeight: CGFloat = 44.0 {
        didSet { self.tableView.estimatedRowHeight = self.tableEstimatedRowHeight }
    }
    open var tableRowHeight: CGFloat = UITableView.automaticDimension {
        didSet { self.tableView.rowHeight = self.tableRowHeight }
    }
    open var cellBackgroundColor: UIColor = UIColor.white {
        didSet { self.tableView.reloadData() }
    }
    open var footerBackgroundColor: UIColor = UIColor.white {
        didSet { self.footerView.backgroundColor = self.footerBackgroundColor }
    }
    open var footerSpacing: CGFloat = 8 {
        didSet { self.footerView.spacing = self.footerSpacing }
    }
    
    override open func setupView() {
        super.setupView()
        self.setupHeaderView()
        self.setupTableView()
        self.setupFooterView()
        
        // HOOKS
        self.setupHeader()   
        self.setupFooter()
    }
    
    public func build(_ components: [Component?],
                      divider: Divider) {
        let components: [Component] = components.compactMap { $0 }
        var _components: [Component] = []
        for (i, component) in components.enumerated() {
            _components.append(component)
            if i < components.count - 1 {
                _components.append(divider)
            }
        }
        self.build(_components)
    }
    
    public func build(_ components: [Component?]) {
        let components: [Component] = components.compactMap { $0 }
        self.tableUpdatesQueue.async {
            components.forEach { $0.table = self }
            self.views = components
            self.tableView.reloadData()
        }
    }
    
    private func setupHeaderView() {
        self.headerView.backgroundColor = self.headerBackgroundColor
        self.view.addSubview(self.headerView, with: [
            Anchor.to(self.view).top.safeArea,
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
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = self.tableAlwaysBounceVertical
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
        self.view.addSubview(self.footerView, with: [
            Anchor.to(self.tableView).topToBottom,
            Anchor.to(self.view).bottom.safeArea.connect(self.bottomAnchor),
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
    
    open func setupFooter() {
        // HOOK
    }
}

// MARK: Header
public extension TableViewController {
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
public extension TableViewController {
    func add(_ components: [Component],
             animated: UITableView.RowAnimation = .automatic) {
        for component in components {
            self.add(component, animated: animated)
        }
    }
    
    func add(_ component: Component,
             animated: UITableView.RowAnimation = .automatic) {
        let index: Int = self.views.count
        self.insert(component, at: index, animated: animated)
    }
    
    func insert(_ component: Component,
                after: Component,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: after) else { return }
        self.insert(component, at: index + 1, animated: animated)
    }
    
    func insert(_ components: [Component],
                after: Component,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: after) else { return }
        self.insert(components, at: index, animated: animated)
    }
    
    func insert(_ component: Component,
                before: Component,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: before) else { return }
        self.insert(component, at: index, animated: animated)
    }
    
    func insert(_ components: [Component],
                before: Component,
                animated: UITableView.RowAnimation = .automatic) {
        guard let index: Int = self.views.firstIndex(of: before) else { return }
        self.insert(components, at: index, animated: animated)
    }
    
    func insert(_ components: [Component],
                at index: Int,
                animated: UITableView.RowAnimation = .automatic) {
        for (i, component) in components.enumerated() {
            self.insert(component, at: index + i, animated: animated)
        }
    }
    
    func insert(_ component: Component,
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
    
    func remove(_ components: [Component],
                animated: UITableView.RowAnimation = .automatic) {
        for component in components {
            self.remove(component, animated: animated)
        }
    }
    
    func remove(_ component: Component,
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
public extension TableViewController {
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
public extension TableViewController {
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
public extension TableViewController {
    func updateTableView(animated animate: Bool = true,
                         update: (() -> Void)? = nil) {
        self.tableUpdatesQueue.async {
            self.tableView.shouldAnimate(animate) {
                self.tableView.beginUpdates()
                update?()
                self.tableView.endUpdates()
            }
        }
    }
    
    func refreshTableView() {
        self.refreshTableView(animated: true)
    }
    
    func refreshTableView(animated animate: Bool) {
        self.tableUpdatesQueue.async {
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            self.tableView.shouldAnimate(animate) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
public extension TableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.views.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath)
        cell.backgroundColor = self.cellBackgroundColor
        cell.contentView.subviews.removeFromSuperview()
        let view: Component = self.views[indexPath.row]
        cell.contentView.addSubview(view, with: [
            Anchor.to(cell.contentView).fill
        ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let view: Component = self.views[indexPath.row]
        return view.componentHeight()
    }
}

// MARK: Scroll
public extension TableViewController {
    func scroll(to component: Component,
                at position: UITableView.ScrollPosition = UITableView.ScrollPosition.middle,
                animated: Bool = true) {
        guard let index: Int = self.views.firstIndex(of: component) else { return }
        self.scroll(to: index, animated: animated)
    }
    
    func scroll(to index: Int,
                at position: UITableView.ScrollPosition = UITableView.ScrollPosition.middle,
                animated: Bool = true) {
        self.tableUpdatesQueue.async {
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: animated)
        }
    }
}

// MARK: Inputs
extension TableViewController { }
