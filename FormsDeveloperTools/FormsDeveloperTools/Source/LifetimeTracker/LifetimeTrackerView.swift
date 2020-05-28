//
//  LifetimeTrackerView.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: LifetimeTrackerView
public protocol LifetimeTrackerView: class {
    func update(with dashboard: LifetimeTrackerDashboard,
                on mainWindow: UIWindow,
                isEnabled: Bool)
}
