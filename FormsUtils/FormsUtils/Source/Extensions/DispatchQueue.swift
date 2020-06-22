//
//  DispatchQueue.swift
//  FormsUtils
//
//  Created by Konrad on 6/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DispatchQueue
public extension DispatchQueue {
    static func asyncMainIfNeeded(_ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
}
