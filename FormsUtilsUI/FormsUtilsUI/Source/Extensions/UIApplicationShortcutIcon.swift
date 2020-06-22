//
//  UIApplicationShortcutIcon.swift
//  FormsUtils
//
//  Created by Konrad on 6/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIApplicationShortcutIcon
public extension UIApplicationShortcutIcon {
    static func from(name: String) -> UIApplicationShortcutIcon? {
        if #available(iOS 13.0, *) {
            return UIApplicationShortcutIcon(systemImageName: name)
        } else {
            return UIApplicationShortcutIcon(templateImageName: name)
        }
    }
}
