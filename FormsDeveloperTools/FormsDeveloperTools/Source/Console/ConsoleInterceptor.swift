//
//  ConsoleInterceptor.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: ConsoleInterceptor
internal class ConsoleInterceptor {
    internal typealias Intercept = (() -> Void)
    
    private var queue: [Intercept] = []
    internal var canIntercept: Bool {
        return !self.queue.isEmpty
    }
    
    internal func save(_ action: @escaping Intercept) {
        self.queue.append(action)
    }
    
    internal func intercept() {
        DispatchQueue.main.sync {
            let intercept: Intercept = self.queue.removeFirst()
            intercept()
        }
    }
}
