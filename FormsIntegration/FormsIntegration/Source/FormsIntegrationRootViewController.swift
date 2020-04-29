//
//  FormsIntegrationRootViewController.swift
//  FormsIntegration
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

private enum Integration {
    enum RowType {
        // Analytics
        case analytics
        // Developer Tools
        case developerTools
        // SideMenu
        case sideMenu
        // SocialKit
        case socialKit
        case socialKitApple
        case socialKitFacebook
        case socialKitGoogle
    }
    
    struct Row {
        var type: RowType
        var title: String?
        var subtitle: String? = nil
        var sections: [Section] = []
        var shouldPresent: Bool = false
    }
    
    struct Section {
        var title: String? = nil
        var rows: [Row] = []
        
        static var `default`: [Section] = {
            return [
                Section(title: "Analytics", rows: [
                    Row(type: .analytics, title: "Analytics")
                ]),
                Section(title: "Developer tools", rows: [
                    Row(type: .developerTools, title: "Developer tools")
                ]),
                Section(title: "Side menu", rows: [
                    Row(type: .sideMenu, title: "Side menu")
                ]),
                Section(title: "SocialKit", rows: [
                    Row(type: .socialKitApple, title: "SocialKit Apple"),
                    Row(type: .socialKitFacebook, title: "SocialKit Facebook"),
                    Row(type: .socialKitGoogle, title: "SocialKit Google")
                ])
            ]
        }()
    }
}

// MARK: [Integration.Section]
fileprivate extension Array where Element == Integration.Section {
    func row(for type: Integration.RowType,
             from sections: [Integration.Section]) -> Integration.Row? {
        for section in sections {
            for row in section.rows {
                if row.type == type { return row }
                guard let result = self.row(for: type, from: row.sections) else { continue }
                return result
            }
        }
        return nil
    }
}

// MARK: FormsIntegrationRootViewController
public class FormsIntegrationRootViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        Forms.initialize(Injector.main)
        self.setupView()
    }
    
    public func setupView() {
        let controller = FormsIntegrationListViewController(items: Integration.Section.default)
        controller.title = "FormsIntegration"
        self.viewControllers = [controller]
        self.autoroute(to: nil, in: controller)
    }
    
    private func autoroute(to rowType: Integration.RowType?,
                           in controller: FormsIntegrationListViewController) {
        guard let rowType: Integration.RowType = rowType else { return }
        let sections: [Integration.Section] = Integration.Section.default
        guard let row: Integration.Row = Integration.Section.default.row(for: rowType, from: sections) else { return }
        controller.select(row: row)
    }
}

// MARK: FormsIntegrationListViewController
private class FormsIntegrationListViewController: FormsViewController {
    private let tableView: UITableView = UITableView(
        frame: CGRect(width: 320, height: 44),
        style: .plain)
    
    private var items: [Integration.Section] = []
    private let defaultCellIdentifier: String = "_cell"
    private let injector: Injector = Injector.main
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.items = Integration.Section.default
    }
    
    init(items: [Integration.Section]) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
    }
    
    init(row: Integration.Row) {
        super.init(nibName: nil, bundle: nil)
        self.title = row.title
        self.items = row.sections
    }
    
    override func setupView() {
        super.setupView()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = true
        self.tableView.alwaysBounceVertical = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.tableView, with: [
            Anchor.to(self.view).fill
        ])
    }
    
    fileprivate func select(row: Integration.Row) {
        if !row.sections.isEmpty {
            let controller = FormsIntegrationListViewController(row: row)
            self.show(controller, sender: nil)
        } else {
            guard let controller: UIViewController = self.rowController(row: row) else { return }
            controller.title = row.title
            if row.shouldPresent {
                self.present(controller, animated: true, completion: nil)
            } else {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func rowController(row: Integration.Row) -> UIViewController? {
        switch row.type {
        // Analytics
        case .analytics:                return FormsIntegrationAnalyticsViewController()
        // DeveloperTools
        case .developerTools:           return FormsIntegrationDeveloperToolsViewController()
        // SideMenu
        case .sideMenu:                 return FormsIntegrationSideMenuViewController()
        // SocialKit
        case .socialKitApple:           return FormsIntegrationSocialKitAppleViewController()
        case .socialKitFacebook:        return FormsIntegrationSocialKitFacebookViewController()
        case .socialKitGoogle:          return FormsIntegrationSocialKitGoogleViewController()
        default:                        return nil
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension FormsIntegrationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item: Integration.Section = self.items[section]
        return item.rows.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: Integration.Section = self.items[indexPath.section]
        let row: Integration.Row = item.rows[indexPath.row]
        self.select(row: row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items.count.greaterThan(1) ? self.items[section].title : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath)
        let item: Integration.Section = self.items[indexPath.section]
        let row: Integration.Row = item.rows[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.items.count.greaterThan(1) ? 30.0 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
