//
//  Utils.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDeveloperTools
import FormsHomeShortcuts
import FormsInjector
import UIKit

// MARK: AppAssembly
public class DemoAssembly: Assembly {
    public init() { }
    
    public func assemble(injector: Injector) {
        injector.register(HomeShortcutsProtocol.self) { _ in
            HomeShortcuts.shared
        }
    }
}

// MARK: DemoDeveloperToolsManager
public enum DemoDeveloperToolsManager {
    public static func onSelect(_ key: DeveloperFeatureKey,
                                _ rootController: UIViewController) {
        guard let controller = Self.controller(for: key) else { return }
        rootController.show(controller, sender: nil)
    }
    
    private static func controller(for key: DeveloperFeatureKey) -> UIViewController? {
        switch key.rawKey {
        case DemoDeveloperFeatureKeys.firstFeature.rawKey:
            return DemoDeveloperToolsMenuFirstFeatureViewController()
        case DemoDeveloperFeatureKeys.secondFeature.rawKey:
            return DemoDeveloperToolsMenuSecondFeatureViewController()
        default:
            return nil
        }
    }
}

// MARK: DemoDeveloperFeatureKeys
public enum DemoDeveloperFeatureKeys: String, CaseIterable, DeveloperFeatureKey {
    case firstFeature
    case secondFeature
    
    public var title: String {
        switch self {
        case .firstFeature: return "First Feature"
        case .secondFeature: return "Second Feature"
        }
    }
}

// MARK: DemoDeveloperFeatureFlagKeys
public enum DemoDeveloperFeatureFlagKeys: String, CaseIterable, DeveloperFeatureFlagKey {
    case firstFeatureFlag
    case secondFeatureFlag
    
    public var title: String {
        switch self {
        case .firstFeatureFlag: return "First Feature Flag"
        case .secondFeatureFlag: return "Second Feature Flag"
        }
    }
}

// MARK: HomeShortcutsKeysProtocol
public enum DemoHomeShortcutsKeys: String, CaseIterable, HomeShortcutsKeysProtocol {
    case option1
    case option2
    
    public var item: HomeShortcutItem {
        let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""
        switch self {
        case .option1:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_1",
                title: "Title option 1",
                subtitle: "Subtitle option 1",
                icon: UIApplicationShortcutIcon(systemImageName: "square.and.arrow.up"),
                userInfo: nil)
        case .option2:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_2",
                title: "Title option 2",
                subtitle: "Subtitle option 2",
                icon: UIApplicationShortcutIcon(systemImageName: "paperplane.fill"),
                userInfo: nil)
        }
    }
}
