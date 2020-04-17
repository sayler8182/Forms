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
        case controller
        case pagerController
        case tabBarController
        case tableViewController
        case viewController
        // Components
        case components
        case componentsButtons
        case componentsButtonsPrimaryButton
        case componentsInputs
        case componentsInputsTitleTextField
        case componentsLabels
        case componentsNavigationBars
        case componentsNavigationBarsNavigationBar
        case componentsNavigationBarsNavigationBarWithBack
        case componentsNavigationBarsNavigationBarWithClose
        case componentsOthers
        case componentsUtils
        // Utils
        case utils
        case utilsAttributedString
        case utilsLoader
        case utilsModal
        case utilsNetwork
        case utilsNetworkGet
        case utilsNetworkImage
        case utilsShimmer
        case utilsShimmerPaginationTable
        case utilsShimmerShimmer
        case utilsShimmerTable
        case utilsSocialKit
        case utilsSocialKitAll
        case utilsSocialKitApple
        case utilsSocialKitFacebook
        case utilsSocialKitGoogle
        case utilsToast
        case utilsTransition
        case utilsValidators
        // Architectures
        case architectures
        case architecturesClean
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
                        type: .componentsButtons,
                        title: "Buttons",
                        sections: [
                            Section(rows: [
                                Row(type: .componentsButtonsPrimaryButton, title: "PrimaryButton")
                            ])
                    ]),
                    Row(
                        type: .componentsInputs,
                        title: "Inputs",
                        sections: [
                            Section(rows: [
                                Row(type: .componentsInputsTitleTextField, title: "TitleTextField")
                            ])
                    ]),
                    Row(type: .componentsLabels, title: "Labels"),
                    Row(
                        type: .componentsNavigationBars,
                        title: "NavigationBars",
                        sections: [
                            Section(rows: [
                                Row(type: .componentsNavigationBarsNavigationBar, title: "NavigationBar"),
                                Row(type: .componentsNavigationBarsNavigationBarWithBack, title: "NavigationBar with back"),
                                Row(type: .componentsNavigationBarsNavigationBarWithClose, title: "NavigationBar with close", shouldPresent: true)
                            ])
                    ]),
                    Row(type: .componentsOthers, title: "Others"),
                    Row(type: .componentsUtils, title: "Utils")
                ]),
                Section(title: "Utils", rows: [
                    Row(type: .utilsAttributedString, title: "AttributedString"),
                    Row(type: .utilsLoader, title: "Loader"),
                    Row(type: .utilsModal, title: "Modal"),
                    Row(
                        type: .utilsNetwork,
                        title: "Network",
                        sections: [
                            Section(rows: [
                                Row(type: .utilsNetworkGet, title: "Network Get"),
                                Row(type: .utilsNetworkImage, title: "Network Image")
                            ])
                    ]),
                    Row(
                        type: .utilsShimmer,
                        title: "Shimmer",
                        sections: [
                            Section(rows: [
                                Row(type: .utilsShimmerPaginationTable, title: "Pagination Table"),
                                Row(type: .utilsShimmerShimmer, title: "Shimmer"),
                                Row(type: .utilsShimmerTable, title: "Shimmer Table")
                            ])
                    ]),
                    Row(
                        type: .utilsSocialKit,
                        title: "SocialKit",
                        sections: [
                            Section(rows: [
                                Row(type: .utilsSocialKitAll, title: "SocialKit All"),
                                Row(type: .utilsSocialKitApple, title: "SocialKit Apple"),
                                Row(type: .utilsSocialKitFacebook, title: "SocialKit Facebook"),
                                Row(type: .utilsSocialKitGoogle, title: "SocialKit Google")
                            ])
                    ]),
                    Row(type: .utilsToast, title: "Toast"),
                    Row(type: .utilsTransition, title: "Transition", shouldPresent: true),
                    Row(type: .utilsValidators, title: "Validators")
                ]),
                Section(title: "Architectures", rows: [
                    Row(type: .architecturesClean, title: "Clean Swift")
                ])
            ]
        }()
    }
}

// MARK: DemoRootViewController
public class DemoRootViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        Forms.initialize(Injector.main, [
            DemoArchitecturesCleanAssembly(),
            DemoArchitecturesCleanSummaryAssembly()
        ])
        self.setupView()
    }
    
    public func setupView() {
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
    private let defaultCellIdentifier: String = "_cell"
    private let injector: Injector = Injector.main
    
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
        self.tableView.backgroundColor = UIColor.systemBackground
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = true
        self.tableView.alwaysBounceVertical = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.tableView, with: [
            Anchor.to(self.view).fill
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
        case .pagerController:                                  return DemoPagerController()
        case .tabBarController:                                 return DemoTabBarController()
        case .tableViewController:                              return DemoTableViewController()
        case .viewController:                                   return DemoViewController()
        // components
        case .componentsButtonsPrimaryButton:                   return DemoPrimaryButtonViewController()
        case .componentsInputsTitleTextField:                   return DemoTitleTextFieldViewController()
        case .componentsLabels:                                 return DemoLabelsViewController()
        case .componentsNavigationBarsNavigationBar:            return DemoNavigationBarViewController()
        case .componentsNavigationBarsNavigationBarWithBack:    return DemoNavigationBarWithBackOrCloseViewController()
        case .componentsNavigationBarsNavigationBarWithClose:   return DemoNavigationBarWithBackOrCloseViewController()
.with(navigationController: UINavigationController())
        case .componentsOthers:                                 return DemoOthersViewController()
        case .componentsUtils:                                  return DemoUtilsViewController()
        // utils
        case .utilsAttributedString:                            return DemoAttributedStringViewController()
        case .utilsLoader:                                      return DemoLoaderViewController()
        case .utilsModal:                                       return DemoModalViewController()
        case .utilsNetworkGet:                                  return DemoNetworkGetViewController()
        case .utilsNetworkImage:                                return DemoNetworkImageViewController()
        case .utilsShimmerPaginationTable:                      return DemoShimmerPaginationTableViewController()
        case .utilsShimmerShimmer:                              return DemoShimmerViewController()
        case .utilsShimmerTable:                                return DemoShimmerTableViewController()
        case .utilsSocialKitAll:                                return DemoSocialKitAllTableViewController()
        case .utilsSocialKitApple:                              return DemoSocialKitAppleTableViewController()
        case .utilsSocialKitFacebook:                           return DemoSocialKitFacebookTableViewController()
        case .utilsSocialKitGoogle:                             return DemoSocialKitGoogleTableViewController()
        case .utilsToast:                                       return DemoToastViewController()
        case .utilsTransition:                                  return DemoTransitionViewController()
        case .utilsValidators:                                  return DemoValidatorsViewController()
        // architectures
        case .architecturesClean:                       return self.injector.resolve(DemoArchitecturesCleanViewController.self)
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
