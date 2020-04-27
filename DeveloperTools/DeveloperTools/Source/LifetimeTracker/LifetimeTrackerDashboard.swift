//
//  LifetimeTrackerDashboard.swift
//  DeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public struct LifetimeTrackerDashboard {
    let leaksCount: Int
    let groupLeaksCount: Int
    let sections: [GroupModel]

    init(leaksCount: Int,
         groupLeaksCount: Int,
         sections: [GroupModel]) {
        self.leaksCount = leaksCount
        self.groupLeaksCount = groupLeaksCount
        self.sections = sections
    }
}
