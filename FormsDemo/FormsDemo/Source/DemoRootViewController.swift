//
//  DemoRootViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import Forms
import Injector
import UIKit

// MARK: Protocols
public protocol DemoRowType {
    var rawValue: String { get }
}

public protocol DemoRow {
    var type: DemoRowType { get }
    var title: String { get }
    var subtitle: String? { get }
    var sections: [DemoSection] { get }
    var shouldPresent: Bool { get }
}

public protocol DemoSection {
    var title: String? { get }
    var rows: [DemoRow] { get }
}

// MARK: Sections
private enum Demo {
    enum RowType: String, DemoRowType {
        // Section Type
        case custom
        case demo
        // Controllers
        case controller
        case collectionViewController
        case modalController
        case pagerController
        case sideMenuController
        case tabBarController
        case tableViewController
        case viewController
        // Components
        case components
        case componentsButtons
        case componentsButtonsPrimaryButton
        case componentsContainers
        case componentsContainersPage
        case componentsContainersScroll
        case componentsContainersStack
        case componentsInputs
        case componentsInputsSearchBar
        case componentsInputsTitleTextField
        case componentsInputsTitleTextView
        case componentsLabels
        case componentsNavigationBars
        case componentsNavigationBarsNavigationBar
        case componentsNavigationBarsNavigationBarWithBack
        case componentsNavigationBarsNavigationBarWithClose
        case componentsOthers
        case componentsProgresses
        case componentsNavigationProgressBar
        case componentsProgressBars
        case componentsUtils
        // Utils
        case utils
        case utilsAnalytics
        case utilsAppStoreReview
        case utilsAttributedString
        case utilsDeveloperTools
        case utilsDeveloperToolsAutolayout
        case utilsDeveloperToolsLifetime
        case utilsDeveloperToolsMenu
        case utilsImagePicker
        case utilsImagePickerSystem
        case utilsLoader
        case utilsMock
        case utilsModal
        case utilsNetwork
        case utilsNetworkGet
        case utilsNetworkImage
        case utilsPermissions
        case utilsScrollSteps
        case utilsShimmer
        case utilsShimmerPaginationCollection
        case utilsShimmerPaginationTable
        case utilsShimmerCollection
        case utilsShimmerShimmer
        case utilsShimmerTable
        case utilsSocialKit
        case utilsSocialKitAll
        case utilsSocialKitApple
        case utilsSocialKitFacebook
        case utilsSocialKitGoogle
        case utilsStorage
        case utilsTheme
        case utilsToast
        case utilsTransitions
        case utilsTransitionsController
        case utilsTransitionsNavigation
        case utilsValidators
        // Architectures
        case architectures
        case architecturesClean
    }
    
    struct Row: DemoRow {
        var type: DemoRowType
        var title: String
        var subtitle: String? = nil
        var sections: [DemoSection] = []
        var shouldPresent: Bool = false
    }
    
    struct Section: DemoSection {
        var title: String? = nil
        var rows: [DemoRow] = []
        
        static var `default`: [Section] = {
            return [
                Section(title: "Controllers", rows: [
                    Row(type: RowType.collectionViewController, title: "FormsCollectionViewController"),
                    Row(type: RowType.modalController, title: "FormsModalController"),
                    Row(type: RowType.pagerController, title: "FormsPagerController"),
                    Row(type: RowType.sideMenuController, title: "SideMenuController", shouldPresent: true),
                    Row(type: RowType.tabBarController, title: "FormsTabBarController", shouldPresent: true),
                    Row(type: RowType.tableViewController, title: "FormsTableViewController"),
                    Row(type: RowType.viewController, title: "FormsViewController")
                ]),
                Section(title: "Components", rows: [
                    Row(
                        type: RowType.componentsButtons,
                        title: "Buttons",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.componentsButtonsPrimaryButton, title: "PrimaryButton")
                            ])
                    ]),
                    Row(
                        type: RowType.componentsContainers,
                        title: "Containers",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.componentsContainersPage, title: "PageContainer"),
                                Row(type: RowType.componentsContainersScroll, title: "ScrollContainer"),
                                Row(type: RowType.componentsContainersStack, title: "StackContainer")
                            ])
                    ]),
                    Row(
                        type: RowType.componentsInputs,
                        title: "Inputs",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.componentsInputsSearchBar, title: "SearchBar"),
                                Row(type: RowType.componentsInputsTitleTextField, title: "TitleTextField"),
                                Row(type: RowType.componentsInputsTitleTextView, title: "TitleTextView")
                            ])
                    ]),
                    Row(type: RowType.componentsLabels, title: "Labels"),
                    Row(
                        type: RowType.componentsNavigationBars,
                        title: "NavigationBars",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.componentsNavigationBarsNavigationBar, title: "NavigationBar"),
                                Row(type: RowType.componentsNavigationBarsNavigationBarWithBack, title: "NavigationBar with back"),
                                Row(type: RowType.componentsNavigationBarsNavigationBarWithClose, title: "NavigationBar with close", shouldPresent: true)
                            ])
                    ]),
                    Row(type: RowType.componentsOthers, title: "Others"),
                    Row(
                        type: RowType.componentsProgresses,
                        title: "Progresses",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.componentsNavigationProgressBar, title: "NavigationProgress", shouldPresent: true),
                                Row(type: RowType.componentsProgressBars, title: "ProgressBar")
                            ])
                    ]),
                    Row(type: RowType.componentsUtils, title: "Utils")
                ]),
                Section(title: "Utils", rows: [
                    Row(type: RowType.utilsAnalytics, title: "Analytics"),
                    Row(type: RowType.utilsAppStoreReview, title: "AppStoreReview"),
                    Row(type: RowType.utilsAttributedString, title: "AttributedString"),
                    Row(
                        type: RowType.utilsDeveloperTools,
                        title: "DeveloperTools",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.utilsDeveloperToolsAutolayout, title: "Autolayout"),
                                Row(type: RowType.utilsDeveloperToolsLifetime, title: "Lifetime"),
                                Row(type: RowType.utilsDeveloperToolsMenu, title: "Menu")
                            ])
                    ]),
                    Row(
                        type: RowType.utilsImagePicker,
                        title: "ImagePicker",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.utilsImagePickerSystem, title: "System")
                            ])
                    ]),
                    Row(type: RowType.utilsLoader, title: "Loader"),
                    Row(type: RowType.utilsMock, title: "Mock"),
                    Row(type: RowType.utilsModal, title: "Modal"),
                    Row(
                        type: RowType.utilsNetwork,
                        title: "Network",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.utilsNetworkGet, title: "Network Get"),
                                Row(type: RowType.utilsNetworkImage, title: "Network Image")
                            ])
                    ]),
                    Row(type: RowType.utilsPermissions, title: "Permissions"),
                    Row(type: RowType.utilsScrollSteps, title: "ScrollSteps"),
                    Row(
                        type: RowType.utilsShimmer,
                        title: "Shimmer",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.utilsShimmerPaginationCollection, title: "Pagination Collection"),
                                Row(type: RowType.utilsShimmerPaginationTable, title: "Pagination Table"),
                                Row(type: RowType.utilsShimmerCollection, title: "Shimmer Collection"),
                                Row(type: RowType.utilsShimmerShimmer, title: "Shimmer"),
                                Row(type: RowType.utilsShimmerTable, title: "Shimmer Table")
                            ])
                    ]),
                    Row(
                        type: RowType.utilsSocialKit,
                        title: "SocialKit",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.utilsSocialKitAll, title: "SocialKit All"),
                                Row(type: RowType.utilsSocialKitApple, title: "SocialKit Apple"),
                                Row(type: RowType.utilsSocialKitFacebook, title: "SocialKit Facebook"),
                                Row(type: RowType.utilsSocialKitGoogle, title: "SocialKit Google")
                            ])
                    ]),
                    Row(type: RowType.utilsStorage, title: "Storage"),
                    Row(type: RowType.utilsTheme, title: "Theme"),
                    Row(type: RowType.utilsToast, title: "Toast"),
                    Row(
                        type: RowType.utilsTransitions,
                        title: "Transitions",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.utilsTransitionsController, title: "Transitions Controller"),
                                Row(type: RowType.utilsTransitionsNavigation, title: "Transitions Navigation", shouldPresent: true)
                            ])
                    ]),
                    Row(type: RowType.utilsValidators, title: "Validators")
                ]),
                Section(title: "Architectures", rows: [
                    Row(type: RowType.architecturesClean, title: "Clean Swift")
                ])
            ]
        }()
    }
}

// MARK: [DemoSection]
fileprivate extension Array where Element == DemoSection {
    static func rows(from sections: [DemoSection]) -> [DemoRow] {
        var rows: [DemoRow] = []
        for section in sections {
            rows.append(contentsOf: section.rows)
            for row in section.rows {
                let result = Self.rows(from: row.sections)
                rows.append(contentsOf: result)
            }
        }
        return rows
    }
    
    static func row(for type: DemoRowType,
                    from sections: [DemoSection]) -> DemoRow? {
        for section in sections {
            for row in section.rows {
                if row.type.rawValue == type.rawValue { return row }
                guard let result = Self.row(for: type, from: row.sections) else { continue }
                return result
            }
        }
        return nil
    }
}

// MARK: DemoRootViewController
public class DemoRootViewController: FormsNavigationController {
    public typealias GetRowController = (DemoRow) -> UIViewController?
    
    private var sections: [DemoSection] = []
    private var getRowController: GetRowController
    
    public init(_ sections: [DemoSection],
                _ getRowController: @escaping GetRowController) {
        self.sections = sections
        self.getRowController = getRowController
        super.init(nibName: nil, bundle: nil)
    }
    
    override public init() {
        self.sections = []
        self.getRowController = { _ in nil }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.sections = []
        self.getRowController = { _ in nil }
        super.init(coder: coder)
    }
    
    override public func postInit() {
        super.postInit()
        Forms.assemble(Injector.main, [
            DemoArchitecturesCleanAssembly(),
            DemoArchitecturesCleanSummaryAssembly()
        ])
        let items: [DemoSection] = self.prepareItems()
        let controller = DemoListViewController(items, self.getRowController)
            .with(title: "FormsDemo")
        self.setRoot(controller)
    }
    
    override public func setupView() {
        super.setupView()
        self.autoroute(to: nil)
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            Theme.setUserInterfaceStyle(self.traitCollection.userInterfaceStyle)
        }
    }
    
    private func prepareItems() -> [DemoSection] {
        let defaultSections: [DemoSection] = Demo.Section.default
        guard self.sections.isNotEmpty else { return defaultSections }
        return [
            Demo.Section(rows: [
                Demo.Row(type: Demo.RowType.custom, title: "Custom", sections: self.sections)
            ]),
            Demo.Section(rows: [
                Demo.Row(type: Demo.RowType.demo, title: "Demo", sections: defaultSections)
            ])
        ]
    }
    
    private func autoroute(to rowType: DemoRowType?) {
        guard let rowType: DemoRowType = rowType else { return }
        let sections: [DemoSection] = Demo.Section.default
        guard let row: DemoRow = [DemoSection].row(for: rowType, from: sections) else { return }
        guard let controller = self.rootViewController(of: DemoListViewController.self) else { return }
        controller.select(row: row)
    }
}

// MARK: DemoListViewController
private class DemoListViewController: FormsViewController {
    typealias GetRowController = (DemoRow) -> UIViewController?
    
    private let tableView: UITableView = UITableView(
        frame: CGRect(width: 320, height: 44),
        style: .plain)
    
    private lazy var searchDataSource = SearchDataSource<DemoSection>(self.tableView)
    private lazy var searchController = FormsSearchController(self.searchDataSource)
    
    private var items: [DemoSection] {
        get { return self.searchDataSource.items }
        set { self.searchDataSource.items = newValue }
    }
    private let defaultCellIdentifier: String = "_cell"
    private let injector: Injector = Injector.main
    
    private var getRowController: GetRowController
    
    required init?(coder: NSCoder) {
        self.getRowController = { _ in nil }
        super.init(coder: coder)
        self.items = []
    }
    
    init(_ items: [DemoSection],
         _ getRowController: @escaping GetRowController) {
        self.getRowController = { _ in nil }
        super.init(nibName: nil, bundle: nil)
        self.items = items
    }
    
    init(_ row: DemoRow,
         _ getRowController: @escaping GetRowController) {
        self.getRowController = { _ in nil }
        super.init(nibName: nil, bundle: nil)
        self.title = row.title
        self.items = row.sections
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(
                input: "f",
                modifierFlags: .command,
                action: #selector(searchCommand),
                discoverabilityTitle: "Search")
        ]
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func setupContent() {
        super.setupContent()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.estimatedRowHeight = 44
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = true
        self.tableView.alwaysBounceVertical = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.tableView, with: [
            Anchor.to(self.view).fill
        ]) 
    }
    
    override func setupSearchBar() {
        super.setupSearchBar()
        self.setSearchBar(self.searchController)
    }
    
    override func setupActions() {
        super.setupActions()
        self.searchDataSource.onFilter = { (items, query) in
            let rows: [DemoRow] = [DemoSection]
                .rows(from: items)
                .filter { $0.title.localizedCaseInsensitiveContains(query) }
            return [Demo.Section(title: "Search Result", rows: rows)]
        }
    }
    
    fileprivate func select(row: DemoRow) {
        if !row.sections.isEmpty {
            let controller = DemoListViewController(row, self.getRowController)
            self.show(controller, sender: nil)
        } else if let controller: UIViewController = self.rowController(row) {
            self.show(row, controller)
        } else if let controller: UIViewController = self.getRowController(row) {
            self.show(row, controller)
        }
    }
    
    private func show(_ row: DemoRow, _ controller: UIViewController) {
        controller.title = row.title
        if row.shouldPresent {
            self.present(controller, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func rowController(_ row: DemoRow) -> UIViewController? {
        guard let type: Demo.RowType = row.type as? Demo.RowType else { return nil }
        switch type {
        // controllers
        case .collectionViewController:                         return DemoCollectionViewController()
        case .modalController:                                  return DemoModalController()
        case .pagerController:                                  return DemoPagerController()
        case .sideMenuController:                               return DemoSideMenuController()
        case .tabBarController:                                 return DemoTabBarController()
        case .tableViewController:                              return DemoTableViewController()
        case .viewController:                                   return DemoViewController()
        // components
        case .componentsButtonsPrimaryButton:                   return DemoPrimaryButtonViewController()
        case .componentsContainersPage:                         return DemoPageContainerViewController()
        case .componentsContainersScroll:                       return DemoScrollContainerViewController()
        case .componentsContainersStack:                        return DemoStackContainerViewController()
        case .componentsInputsSearchBar:                        return DemoSearchBarViewController()
        case .componentsInputsTitleTextField:                   return DemoTitleTextFieldViewController()
        case .componentsInputsTitleTextView:                    return DemoTitleTextViewViewController()
        case .componentsLabels:                                 return DemoLabelsViewController()
        case .componentsNavigationBarsNavigationBar:            return DemoNavigationBarViewController()
        case .componentsNavigationBarsNavigationBarWithBack:    return DemoNavigationBarWithBackOrCloseViewController()
        case .componentsNavigationBarsNavigationBarWithClose:   return DemoNavigationBarWithBackOrCloseViewController().embeded
        case .componentsOthers:                                 return DemoOthersViewController()
        case .componentsNavigationProgressBar:                  return DemoNavigationProgressBarViewController()
        case .componentsProgressBars:                           return DemoProgressBarViewController()
        case .componentsUtils:                                  return DemoUtilsViewController()
        // utils
        case .utilsAnalytics:                                   return DemoAnalyticsViewController()
        case .utilsAppStoreReview:                              return DemoAppStoreReviewViewController()
        case .utilsAttributedString:                            return DemoAttributedStringViewController()
        case .utilsDeveloperToolsAutolayout:                    return DemoDeveloperToolsAutolayoutViewController()
        case .utilsDeveloperToolsLifetime:                      return DemoDeveloperToolsLifetimeViewController()
        case .utilsDeveloperToolsMenu:                          return DemoDeveloperToolsMenuViewController()
        case .utilsImagePickerSystem:                           return DemoImagePickerSystemViewController()
        case .utilsLoader:                                      return DemoLoaderViewController()
        case .utilsMock:                                        return DemoMockViewController()
        case .utilsModal:                                       return DemoModalViewController()
        case .utilsNetworkGet:                                  return DemoNetworkGetViewController()
        case .utilsNetworkImage:                                return DemoNetworkImageViewController()
        case .utilsPermissions:                                 return DemoPermissionsViewController()
        case .utilsScrollSteps:                                 return DemoScrollStepsViewController()
        case .utilsShimmerPaginationCollection:                 return DemoShimmerPaginationCollectionViewController()
        case .utilsShimmerPaginationTable:                      return DemoShimmerPaginationTableViewController()
        case .utilsShimmerCollection:                           return DemoShimmerCollectionViewController()
        case .utilsShimmerShimmer:                              return DemoShimmerViewController()
        case .utilsShimmerTable:                                return DemoShimmerTableViewController()
        case .utilsSocialKitAll:                                return DemoSocialKitAllTableViewController()
        case .utilsSocialKitApple:
            if #available(iOS 13.0, *) {
                return DemoSocialKitAppleTableViewController()
            } else {
                return nil
            }
        case .utilsSocialKitFacebook:                           return DemoSocialKitFacebookTableViewController()
        case .utilsSocialKitGoogle:                             return DemoSocialKitGoogleTableViewController()
        case .utilsToast:                                       return DemoToastViewController()
        case .utilsStorage:                                     return DemoStorageViewController()
        case .utilsTheme:                                       return DemoThemeViewController()
        case .utilsTransitionsController:                       return DemoTransitionControllerViewController()
        case .utilsTransitionsNavigation:                       return DemoTransitionNavigationViewController()
        case .utilsValidators:                                  return DemoValidatorsViewController()
        // architectures
        case .architecturesClean:                               return self.injector.resolve(DemoArchitecturesCleanViewController.self)
        default:                                                return nil
        }
    }
    
    @objc
    private func searchCommand(sender: UIKeyCommand) {
        if self.searchController.searchBar.isFirstResponder {
            self.searchController.searchBar.resignFirstResponder()
        } else {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: DemoSection = self.items[indexPath.section]
        let row: DemoRow = item.rows[indexPath.row]
        self.select(row: row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: String? = self.items.count > 1 ? self.items[section].title : nil
        guard let _title: String = title else { return nil }
        return Components.sections.default()
            .with(text: _title)
            .with(width: tableView.frame.width)
    } 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifier, for: indexPath)
        let item: DemoSection = self.items[indexPath.section]
        let row: DemoRow = item.rows[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = Theme.Colors.primaryText
        cell.detailTextLabel?.textColor = Theme.Colors.secondaryText
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.items.count > 1 ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
