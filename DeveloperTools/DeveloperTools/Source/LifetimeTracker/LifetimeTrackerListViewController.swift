//
//  LifetimeTrackerListViewController.swift
//  DeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: LifetimeTrackerListViewController
class LifetimeTrackerListViewController: UIViewController {
    private let tableView = UITableView(
        frame: CGRect(x: 0, y: 0, width: 320, height: 44),
        style: .plain)
    
    private var dashboard: LifetimeTrackerDashboard?
    private var window: UIWindow?
    
    private let defaultHeaderIdentifier: String = "_header"
    private let defaultCellIdentifier: String = "_cell"
    
    init(dashboard: LifetimeTrackerDashboard?) {
        self.dashboard = dashboard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.setupNavigationBar()
        self.setupTableView()
    }
    
    private func setupNavigationBar() {
        self.title = "LifetimeTracker"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeBarButtonClick))
    }
    
    private func setupTableView() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.register(LifetimeTrackerDashboardHeaderView.self, forHeaderFooterViewReuseIdentifier: self.defaultHeaderIdentifier)
        self.tableView.register(LifetimeTrackerDashboardTableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func update(dashboard: LifetimeTrackerDashboard?) {
        self.dashboard = dashboard
        self.tableView.reloadData()
    }
    
    func show() {
        let window: UIWindow = LifetimeTrackerManager.newWindow
        window.windowLevel = UIWindow.Level.statusBar + 1
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        window.isHidden = false
        self.window = window
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    private func closeBarButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.window?.isHidden = true
            self.window = nil
        }
    }
}

// MARK: UITableViewDelegate,  UITableViewDataSource
extension LifetimeTrackerListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dashboard = self.dashboard else { return 0 }
        return dashboard.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dashboard = self.dashboard else { return 0 }
        guard section < dashboard.sections.count else { return 0 }
        return dashboard.sections[section].entries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dashboard = self.dashboard else { return nil }
        guard section < dashboard.sections.count else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.defaultHeaderIdentifier) as! LifetimeTrackerDashboardHeaderView
        let section = dashboard.sections[section]
        headerView.fill(
            color: section.color,
            title: section.title)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dashboard = self.dashboard else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath) as! LifetimeTrackerDashboardTableViewCell
        let group = dashboard.sections[indexPath.section]
        let entry = group.entries[indexPath.row]
        cell.fill(
            groupColor: group.color,
            classColor: entry.color,
            description: entry.description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: LifetimeTrackerDashboardHeaderView
class LifetimeTrackerDashboardHeaderView: UITableViewHeaderFooterView {
    private var indicatorView = UIView()
    private var groupNameLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundView?.backgroundColor = UIColor.black
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorView.backgroundColor = UIColor.clear
        self.addSubview(self.indicatorView)
        NSLayoutConstraint.activate([
            self.indicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.indicatorView.widthAnchor.constraint(equalToConstant: 10)
        ])
        self.groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.groupNameLabel.font = UIFont.systemFont(ofSize: 14)
        self.groupNameLabel.textColor = UIColor.white
        self.addSubview(self.groupNameLabel)
        NSLayoutConstraint.activate([
            self.groupNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.groupNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.groupNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.groupNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.indicatorView.backgroundColor = UIColor.clear
        self.groupNameLabel.text = nil
    }
    
    func fill(color: UIColor,
              title: String) {
        self.indicatorView.backgroundColor = color
        self.groupNameLabel.text = title
    }
}

// MARK: LifetimeTrackerDashboardTableViewCell
class LifetimeTrackerDashboardTableViewCell: UITableViewCell {
    private var groupIndicatorView = UIView()
    private var classIndicatorView = UIView()
    private var descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.groupIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.groupIndicatorView.backgroundColor = UIColor.clear
        self.addSubview(self.groupIndicatorView)
        NSLayoutConstraint.activate([
            self.groupIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.groupIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.groupIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.groupIndicatorView.widthAnchor.constraint(equalToConstant: 5)
        ])
        self.classIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.classIndicatorView.backgroundColor = UIColor.clear
        self.addSubview(self.classIndicatorView)
        NSLayoutConstraint.activate([
            self.classIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.classIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.classIndicatorView.leadingAnchor.constraint(equalTo: self.groupIndicatorView.trailingAnchor),
            self.classIndicatorView.widthAnchor.constraint(equalToConstant: 5)
        ])
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        self.descriptionLabel.textColor = UIColor.black
        self.descriptionLabel.numberOfLines = 0
        self.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.groupIndicatorView.backgroundColor = UIColor.clear
        self.classIndicatorView.backgroundColor = UIColor.clear
        self.descriptionLabel.text = nil
    }
    
    func fill(groupColor: UIColor,
              classColor: UIColor,
              description: String) {
        self.groupIndicatorView.backgroundColor = groupColor
        self.classIndicatorView.backgroundColor = classColor
        self.descriptionLabel.text = description
    }
}
