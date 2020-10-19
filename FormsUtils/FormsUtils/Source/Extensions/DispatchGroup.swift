//
//  DispatchGroup.swift
//  FormsUtils
//
//  Created by Konrad on 10/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DispatchGroup
public extension DispatchGroup {
    @discardableResult
    func wait(_ time: TimeInterval) -> DispatchTimeoutResult {
        return self.wait(timeout: DispatchTime.now() + time)
    }
}
