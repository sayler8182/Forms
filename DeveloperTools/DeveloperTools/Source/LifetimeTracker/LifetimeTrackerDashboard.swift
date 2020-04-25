//
//  LifetimeTrackerDashboard.swift
//  DeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

struct LifetimeTrackerDashboard {
    let leaksCount: Int
    let summary: NSAttributedString?
    let sections: [GroupModel]

    init(leaksCount: Int,
         summary: NSAttributedString? = nil,
         sections: [GroupModel]) {
        self.leaksCount = leaksCount
        self.summary = summary
        self.sections = sections
    }
}
