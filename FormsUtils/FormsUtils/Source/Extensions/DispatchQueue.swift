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
    static func async(in queue: DispatchQueue?,
                      execute action: @escaping () -> Void) {
        guard let queue: DispatchQueue = queue else {
            action()
            return
        }
        queue.async(execute: action)
    }
    
    static func asyncMainIfNeeded(_ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.async(execute: action)
        }
    }
}
