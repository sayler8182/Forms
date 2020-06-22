//
//  DeveloperToolsMenuViewController.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DeveloperFeatures
extension DeveloperToolsMenuViewController {
    struct Section {
        var title: String
        var rows: [DeveloperFeatureKeyProtocol]
    }
}

// MARK: DeveloperToolsMenuViewController
public class DeveloperToolsMenuViewController: UIViewController, DeveloperToolsMenu {
    private let tableView = UITableView(
        frame: CGRect(x: 0, y: 0, width: 320, height: 44),
        style: .plain)
    
    private var items: [Section]
    private var onSelect: OnSelect?
    
    private let defaultHeaderIdentifier: String = "_header"
    private let defaultCellIdentifier: String = "_cell"
    private let defaultSwitchCellIdentifier: String = "_switch_cell"
    
    public required init(features: DeveloperFeatures,
                         onSelect: OnSelect?) {
        self.items = [
            Section(title: "Features", rows: features.features),
            Section(title: "FeaturesFlags", rows: features.featuresFlags)
        ]
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.items = []
        super.init(coder: coder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.setupNavigationBar()
        self.setupTableView()
    }
    
    private func setupNavigationBar() {
        self.title = "DeveloperFeatures"
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
        self.tableView.register(DeveloperToolsMenuHeaderView.self, forHeaderFooterViewReuseIdentifier: self.defaultHeaderIdentifier)
        self.tableView.register(DeveloperToolsMenuTableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.tableView.register(DeveloperToolsMenuSwitchTableViewCell.self, forCellReuseIdentifier: self.defaultSwitchCellIdentifier)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    @objc
    private func closeBarButtonClick(_ sender: UIBarButtonItem) {
        let window: UIWindow? = self.view.window
        self.dismiss(animated: true) {
            window?.isHidden = true
        }
    }
}

// MARK: UITableViewDelegate,  UITableViewDataSource
extension DeveloperToolsMenuViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.defaultHeaderIdentifier) as! DeveloperToolsMenuHeaderView
        let section = self.items[section]
        headerView.fill(
            title: section.title)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.items[indexPath.section].rows[indexPath.row]
        if let _row = row as? DeveloperFeatureFlagKeyProtocol {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultSwitchCellIdentifier, for: indexPath) as! DeveloperToolsMenuSwitchTableViewCell
            cell.onChanged = { value in DeveloperTools[_row] = value }
            cell.fill(
                title: _row.title,
                isSelected: DeveloperTools[_row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath) as! DeveloperToolsMenuTableViewCell
            cell.onClick = { [unowned self] in
                self.onSelect?(row, self)
            }
            cell.fill(title: row.title)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: DeveloperToolsMenuHeaderView
class DeveloperToolsMenuHeaderView: UITableViewHeaderFooterView {
    private var titleLabel = UILabel()
    
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
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.white
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
    
    func fill(title: String) {
        self.titleLabel.text = title
    }
}

// MARK: DeveloperToolsMenuTableViewCell
class DeveloperToolsMenuTableViewCell: UITableViewCell {
    private var titleLabel = UILabel()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    fileprivate var onClick: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupActions()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
        self.setupView()
        self.setupActions()
    }
    
    private func setupView() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.numberOfLines = 0
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        self.tapGestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(self.tapGestureRecognizer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
    
    func fill(title: String) {
        self.titleLabel.text = title
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        self.onClick?()
    }
}

// MARK: DeveloperToolsMenuSwitchTableViewCell
class DeveloperToolsMenuSwitchTableViewCell: UITableViewCell {
    private var titleLabel = UILabel()
    private var switchView = UISwitch()
    
    fileprivate var onChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupActions()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
        self.setupView()
        self.setupActions()
    }
    
    private func setupView() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.numberOfLines = 0
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        self.switchView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.switchView)
        NSLayoutConstraint.activate([
            self.switchView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.switchView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.switchView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 8),
            self.switchView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        self.switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.switchView.isOn = true
    }
    
    func fill(title: String,
              isSelected: Bool) {
        self.titleLabel.text = title
        self.switchView.isOn = isSelected
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        self.onChanged?(sender.isOn)
    }
}
