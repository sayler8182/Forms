//
//  HomeShortcuts.swift
//  FormsDemo
//
//  Created by Konrad on 6/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsHomeShortcuts
import UIKit

// MARK: DemoHomeShortcutsKeys
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
                icon: UIApplicationShortcutIcon.from(name: "square.and.arrow.up"),
                userInfo: nil)
        case .option2:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_2",
                title: "Title option 2",
                subtitle: "Subtitle option 2",
                icon: UIApplicationShortcutIcon.from(name: "paperplane.fill"),
                userInfo: nil)
        }
    }
}
