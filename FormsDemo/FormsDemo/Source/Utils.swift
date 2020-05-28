//
//  Utils.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDeveloperTools
import UIKit

// MARK: Utils
enum Utils {
    static func delay(_ delay: Double,
                      _ action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            action()
        }
    }
    
    static func delay<T: AnyObject>(_ delay: Double,
                                    _ target: T,
                                    _ action: @escaping (T) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak target] in
            guard let target: T = target else { return }
            action(target)
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
