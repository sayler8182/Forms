//
//  DeveloperTools.swift
//  FormsDemo
//
//  Created by Konrad on 6/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDeveloperTools
import UIKit

// MARK: DemoDeveloperToolsManager
public enum DemoDeveloperToolsManager {
    public static func onSelect(_ key: DeveloperFeatureKeyProtocol,
                                _ rootController: UIViewController) {
        guard let controller = Self.controller(for: key) else { return }
        rootController.show(controller, sender: nil)
    }
    
    private static func controller(for key: DeveloperFeatureKeyProtocol) -> UIViewController? {
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
public enum DemoDeveloperFeatureKeys: String, CaseIterable, DeveloperFeatureKeyProtocol {
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
public enum DemoDeveloperFeatureFlagKeys: String, CaseIterable, DeveloperFeatureFlagKeyProtocol {
    case firstFeatureFlag
    case secondFeatureFlag
    
    public var title: String {
        switch self {
        case .firstFeatureFlag: return "First Feature Flag"
        case .secondFeatureFlag: return "Second Feature Flag"
        }
    }
}
