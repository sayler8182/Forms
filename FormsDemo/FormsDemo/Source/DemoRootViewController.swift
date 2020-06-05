//
//  DemoRootViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsInjector
import FormsUtils
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
        case tableViewController
        case viewController
        // Components
        case components
        case componentsButtons
        case componentsButtonsPrimaryButton
        case componentsCheckboxes
        case componentsContainers
        case componentsContainersPage
        case componentsContainersScroll
        case componentsContainersStack
        case componentsInputs
        case componentsInputsPinView
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
        case componentsSwitches
        case componentsNavigationProgressBar
        case componentsProgressBars
        case componentsUtils
        // Utils
        case utils
        case utilsAttributedString
        case utilsLoader
        case utilsModal
        case utilsScrollSteps
        case utilsShimmer
        case utilsShimmerPaginationCollection
        case utilsShimmerPaginationTable
        case utilsShimmerCollection
        case utilsShimmerShimmer
        case utilsShimmerTable
        case utilsStorage
        case utilsSVG
        case utilsTheme
        // Frameworks
        case frameworkAnalytics
        case frameworkAppStoreReview
        case frameworkDeveloperTools
        case frameworkDeveloperToolsConsole
        case frameworkDeveloperToolsLifetime
        case frameworkDeveloperToolsMenu
        case frameworkMock
        case frameworkNetwork
        case frameworkNetworkGet
        case frameworkNetworkImage
        case frameworkPermissions
        case frameworkTransitions
        case frameworkTransitionsController
        case frameworkTransitionsNavigation
        case frameworkValidators
        // Kits
        case kitCardKit
        case kitImagePickerKit
        case kitImagePickerKitSystem
        case kitPagerKit
        case kitSideMenuKit
        case kitSocialKit
        case kitSocialKitAll
        case kitSocialKitApple
        case kitSocialKitFacebook
        case kitSocialKitGoogle
        case kitTabBarKit
        case kitToastKit
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
                    Row(type: RowType.componentsCheckboxes, title: "Checkboxes"),
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
                                Row(type: RowType.componentsInputsPinView, title: "PinView"),
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
                    Row(type: RowType.componentsSwitches, title: "Switches"),
                    Row(type: RowType.componentsUtils, title: "Utils")
                ]),
                Section(title: "Utils", rows: [
                    Row(type: RowType.utilsAttributedString, title: "AttributedString"),
                    Row(type: RowType.utilsLoader, title: "Loader"),
                    Row(type: RowType.utilsModal, title: "Modal"),
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
                    Row(type: RowType.utilsStorage, title: "Storage"),
                    Row(type: RowType.utilsSVG, title: "SVG"),
                    Row(type: RowType.utilsTheme, title: "Theme")  
                ]),
                Section(title: "Frameworks", rows: [
                    Row(type: RowType.frameworkAnalytics, title: "Analytics"),
                    Row(type: RowType.frameworkAppStoreReview, title: "AppStoreReview"),
                    Row(
                        type: RowType.frameworkDeveloperTools,
                        title: "DeveloperTools",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.frameworkDeveloperToolsConsole, title: "Console"),
                                Row(type: RowType.frameworkDeveloperToolsLifetime, title: "Lifetime"),
                                Row(type: RowType.frameworkDeveloperToolsMenu, title: "Menu")
                            ])
                    ]),
                    Row(type: RowType.frameworkMock, title: "Mock"),
                    Row(
                        type: RowType.frameworkNetwork,
                        title: "Network",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.frameworkNetworkGet, title: "Network Get"),
                                Row(type: RowType.frameworkNetworkImage, title: "Network Image")
                            ])
                    ]),
                    Row(type: RowType.frameworkPermissions, title: "Permissions"),
                    Row(
                        type: RowType.frameworkTransitions,
                        title: "Transitions",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.frameworkTransitionsController, title: "Transitions Controller"),
                                Row(type: RowType.frameworkTransitionsNavigation, title: "Transitions Navigation", shouldPresent: true)
                            ])
                    ]),
                    Row(type: RowType.frameworkValidators, title: "Validators")
                ]),
                Section(title: "Kits", rows: [
                    Row(type: RowType.kitCardKit, title: "CardKit"),
                    Row(
                        type: RowType.kitImagePickerKit,
                        title: "ImagePickerKit",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.kitImagePickerKitSystem, title: "System")
                            ])
                    ]),
                    Row(type: RowType.kitPagerKit, title: "PagerKit"),
                    Row(type: RowType.kitSideMenuKit, title: "SideMenuKit", shouldPresent: true),
                    Row(
                        type: RowType.kitSocialKit,
                        title: "SocialKit",
                        sections: [
                            Section(rows: [
                                Row(type: RowType.kitSocialKitAll, title: "SocialKit All"),
                                Row(type: RowType.kitSocialKitApple, title: "SocialKit Apple"),
                                Row(type: RowType.kitSocialKitFacebook, title: "SocialKit Facebook"),
                                Row(type: RowType.kitSocialKitGoogle, title: "SocialKit Google")
                            ])
                    ]),
                    Row(type: RowType.kitTabBarKit, title: "TabBarKit", shouldPresent: true),
                    Row(type: RowType.kitToastKit, title: "ToastKit")
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
    
    static func parentRow(parent: DemoRow? = nil,
                          for type: DemoRowType,
                          from sections: [DemoSection]) -> DemoRow? {
           for section in sections {
               for row in section.rows {
                   if row.type.rawValue == type.rawValue { return parent }
                guard let result = Self.parentRow(parent: row, for: type, from: row.sections) else { continue }
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
        controller.searchController.text = row.title
        self.fillPrePath(to: rowType, in: controller, from: sections)
        controller.select(row: row, animated: false)
    }
    
    private func fillPrePath(to rowType: DemoRowType,
                             in controller: DemoListViewController,
                             from sections: [DemoSection]) {
        var rowType: DemoRowType = rowType
        repeat {
            guard let row: DemoRow = [DemoSection].parentRow(for: rowType, from: sections) else { break }
            controller.select(row: row, animated: false)
            rowType = row.type
        } while true
    }
}

// MARK: DemoListViewController
private class DemoListViewController: FormsViewController {
    typealias GetRowController = (DemoRow) -> UIViewController?
    
    private let tableView: UITableView = UITableView(
        frame: CGRect(width: 320, height: 44),
        style: .plain)
    
    fileprivate lazy var searchDataSource = SearchDataSource<DemoSection>(self.tableView)
    fileprivate lazy var searchController = FormsSearchController(self.searchDataSource)
    
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
    
    override func postInit() {
        super.postInit()
        self.searchDataSource.onFilter = { (items, query) in
            let rows: [DemoRow] = [DemoSection]
                .rows(from: items)
                .filter { $0.title.localizedCaseInsensitiveContains(query) }
            return [Demo.Section(title: "Search Result", rows: rows)]
        }
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
    
    fileprivate func select(row: DemoRow, animated: Bool = true) {
        if !row.sections.isEmpty {
            let controller = DemoListViewController(row, self.getRowController)
            self.navigationController?.pushViewController(controller, animated: animated)
        } else if let controller: UIViewController = self.rowController(row) {
            self.show(row, controller, animated)
        } else if let controller: UIViewController = self.getRowController(row) {
            self.show(row, controller, animated)
        }
    }
    
    private func show(_ row: DemoRow, _ controller: UIViewController, _ animated: Bool) {
        controller.title = row.title
        if row.shouldPresent {
            self.present(controller, animated: animated, completion: nil)
        } else {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    private func rowController(_ row: DemoRow) -> UIViewController? {
        guard let type: Demo.RowType = row.type as? Demo.RowType else { return nil }
        switch type {
        // controllers
        case .collectionViewController:                         return DemoCollectionViewController()
        case .tableViewController:                              return DemoTableViewController()
        case .viewController:                                   return DemoViewController()
        // components
        case .componentsButtonsPrimaryButton:                   return DemoPrimaryButtonViewController()
        case .componentsCheckboxes:                             return DemoCheckboxesViewController()
        case .componentsContainersPage:                         return DemoPageContainerViewController()
        case .componentsContainersScroll:                       return DemoScrollContainerViewController()
        case .componentsContainersStack:                        return DemoStackContainerViewController()
        case .componentsInputsPinView:                          return DemoPinViewViewController()
        case .componentsInputsSearchBar:                        return DemoSearchBarViewController()
        case .componentsInputsTitleTextField:                   return DemoTitleTextFieldViewController()
        case .componentsInputsTitleTextView:                    return DemoTitleTextViewViewController()
        case .componentsLabels:                                 return DemoLabelsViewController()
        case .componentsNavigationBarsNavigationBar:            return DemoNavigationBarViewController()
        case .componentsNavigationBarsNavigationBarWithBack:    return DemoNavigationBarWithBackOrCloseViewController()
        case .componentsNavigationBarsNavigationBarWithClose:   return DemoNavigationBarWithBackOrCloseViewController().embeded
        case .componentsNavigationProgressBar:                  return DemoNavigationProgressBarViewController()
        case .componentsOthers:                                 return DemoOthersViewController()
        case .componentsSwitches:                               return DemoSwitchesViewController()
        case .componentsProgressBars:                           return DemoProgressBarViewController()
        case .componentsUtils:                                  return DemoUtilsViewController()
        // utils
        case .utilsAttributedString:                            return DemoAttributedStringViewController()
        case .utilsLoader:                                      return DemoLoaderViewController()
        case .utilsModal:                                       return DemoModalViewController()
        case .utilsScrollSteps:                                 return DemoScrollStepsViewController()
        case .utilsShimmerPaginationCollection:                 return DemoShimmerPaginationCollectionViewController()
        case .utilsShimmerPaginationTable:                      return DemoShimmerPaginationTableViewController()
        case .utilsShimmerCollection:                           return DemoShimmerCollectionViewController()
        case .utilsShimmerShimmer:                              return DemoShimmerViewController()
        case .utilsShimmerTable:                                return DemoShimmerTableViewController()
        case .utilsStorage:                                     return DemoStorageViewController()
        case .utilsSVG:                                         return DemoSVGViewController()
        case .utilsTheme:                                       return DemoThemeViewController()
        // frameworks
        case .frameworkAnalytics:                               return DemoAnalyticsViewController()
        case .frameworkAppStoreReview:                          return DemoAppStoreReviewViewController()
        case .frameworkDeveloperToolsConsole:                   return DemoDeveloperToolsConsoleViewController()
        case .frameworkDeveloperToolsLifetime:                  return DemoDeveloperToolsLifetimeViewController()
        case .frameworkDeveloperToolsMenu:                      return DemoDeveloperToolsMenuViewController()
        case .frameworkMock:                                    return DemoMockViewController()
        case .frameworkNetworkGet:                              return DemoNetworkGetViewController()
        case .frameworkNetworkImage:                            return DemoNetworkImageViewController()
        case .frameworkPermissions:                             return DemoPermissionsViewController()
        case .frameworkTransitionsController:                   return DemoTransitionControllerViewController()
        case .frameworkTransitionsNavigation:                   return DemoTransitionNavigationViewController()
        case .frameworkValidators:                              return DemoValidatorsViewController()
        // kits
        case .kitCardKit:                                       return DemoCardKitController()
        case .kitImagePickerKitSystem:                          return DemoImagePickerKitSystemViewController()
        case .kitPagerKit:                                      return DemoPagerKitController()
        case .kitSideMenuKit:                                   return DemoSideMenuKitController()
        case .kitSocialKitAll:                                  return DemoSocialKitAllTableViewController()
        case .kitSocialKitApple:
            if #available(iOS 13.0, *) {
                return DemoSocialKitAppleTableViewController()
            } else {
                return nil
            }
        case .kitSocialKitFacebook:                             return DemoSocialKitFacebookTableViewController()
        case .kitSocialKitGoogle:                               return DemoSocialKitGoogleTableViewController()
        case .kitTabBarKit:                                     return DemoTabBarKitController()
        case .kitToastKit:                                      return DemoToastKitViewController()
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
        return Components.section.default()
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
