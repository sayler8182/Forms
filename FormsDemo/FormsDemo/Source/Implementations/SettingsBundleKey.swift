//
//  SettingsBundleKey.swift
//  FormsDemo
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Foundation

// MARK: BundleSettings
public enum DemoSettingsBundleKey: String, SettingsBundleKey {
    case environment = "settings_environment"
    case appVersion = "settings_app_version"
    case buildVersion = "settings_build_version"
}
