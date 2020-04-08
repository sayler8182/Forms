//
//  DemoRootViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

private enum Demo {
    enum RowType {
        // Controllers
        case pagerController
        case tabBarController
        case tableViewController
        case viewController
        // Components
        case buttons
        case buttonsPrimaryButton
        case inputs
        case inputsTitleTextField
        case labels
        case navigationBars
        case navigationBarsNavigationBar
        case navigationBarsNavigationBarWithBack
        case navigationBarsNavigationBarWithClose
        // Utils
        case utils
        case utilsAttributedString
        case utilsLoader
        case utilsModal
        case utilsToast
        case utilsValidators
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
                Section(title: "Controllers", rows: [
                    Row(type: .pagerController, title: "PagerController"),
                    Row(type: .tabBarController, title: "TabBarController", shouldPresent: true),
                    Row(type: .tableViewController, title: "TableViewController"),
                    Row(type: .viewController, title: "ViewController")
                ]),
                Section(title: "Components", rows: [
                    Row(
                        type: .buttons,
                        title: "Buttons",
                        sections: [
                            Section(rows: [
                                Row(type: .buttonsPrimaryButton, title: "PrimaryButton")
                            ])
                    ]),
                    Row(
                        type: .inputs,
                        title: "Inputs",
                        sections: [
                            Section(rows: [
                                Row(type: .inputsTitleTextField, title: "TitleTextField")
                            ])
                    ]),
                    Row(type: .labels, title: "Labels"),
                    Row(
                        type: .navigationBars,
                        title: "NavigationBars",
                        sections: [
                            Section(rows: [
                                Row(type: .navigationBarsNavigationBar, title: "NavigationBar"),
                                Row(type: .navigationBarsNavigationBarWithBack, title: "NavigationBar with back"),
                                Row(type: .navigationBarsNavigationBarWithClose, title: "NavigationBar with close", shouldPresent: true)
                            ])
                    ])
                ]),
                Section(title: "Utils", rows: [
                    Row(type: .utilsAttributedString, title: "AttributedString"),
                    Row(type: .utilsLoader, title: "Loader"),
                    Row(type: .utilsModal, title: "Modal"),
                    Row(type: .utilsToast, title: "Toast"),
                    Row(type: .utilsValidators, title: "Validators")
                ])
            ]
        }()
    }
}

// MARK: DemoRootViewController
public class DemoRootViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        Forms.initialize(Injector.main)
        self.setupView()
    }
    
    public func setupView() {
        self.view.backgroundColor = UIColor.white
        let controller: UIViewController = DemoListViewController(items: Demo.Section.default)
        controller.title = "Demo"
        self.viewControllers = [controller]
    }
}

// MARK: DemoListViewController
private class DemoListViewController: ViewController {
    private let tableView: UITableView = UITableView(
        frame: CGRect(width: 320, height: 44),
        style: .plain)
    
    private var items: [Demo.Section] = []
    private let defaultCellIdentifier: String = "cell"
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.items = Demo.Section.default
    }
    
    init(items: [Demo.Section]) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
    }
    
    init(row: Demo.Row) {
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
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = true
        self.tableView.alwaysBounceVertical = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.tableView, with: [
            Anchor.to(self.view).vertical.safeArea,
            Anchor.to(self.view).horizontal.safeArea
        ])
    }
    
    private func select(row: Demo.Row) {
        if !row.sections.isEmpty {
            let controller = DemoListViewController(row: row)
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
    
    private func rowController(row: Demo.Row) -> UIViewController? {
        switch row.type {
        // controllers
        case .pagerController:                          return DemoPagerController()
        case .tabBarController:                         return DemoTabBarController()
        case .tableViewController:                      return DemoTableViewController()
        case .viewController:                           return DemoViewController()
        // components
        case .buttonsPrimaryButton:                     return DemoPrimaryButtonViewController()
        case .inputsTitleTextField:                     return DemoTitleTextFieldViewController()
        case .labels:                                   return DemoLabelsViewController()
        case .navigationBarsNavigationBar:              return DemoNavigationBarViewController()
        case .navigationBarsNavigationBarWithBack:      return DemoNavigationBarWithBackOrCloseViewController()
        case .navigationBarsNavigationBarWithClose:     return DemoNavigationBarWithBackOrCloseViewController().with(navigationController: UINavigationController())
        // utils
        case .utilsAttributedString:                    return DemoAttributedStringViewController()
        case .utilsLoader:                              return DemoLoaderViewController()
        case .utilsModal:                               return DemoModalViewController()
        case .utilsToast:                               return DemoToastViewController()
        case .utilsValidators:                          return DemoValidatorsViewController()
        default:                                        return nil
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item: Demo.Section = self.items[section]
        return item.rows.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: Demo.Section = self.items[indexPath.section]
        let row: Demo.Row = item.rows[indexPath.row]
        self.select(row: row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items.count.greaterThan(1) ? self.items[section].title : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath)
        let item: Demo.Section = self.items[indexPath.section]
        let row: Demo.Row = item.rows[indexPath.row]
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
