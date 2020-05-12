//
//  AutolayoutInterceptor.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: AutolayoutInterceptor
internal class AutolayoutInterceptor {
    internal typealias Intercept = (() -> Void)
    
    private var queue: [Intercept] = []
    internal var canIntercept: Bool {
        return !self.queue.isEmpty
    }
    
    internal func save(_ action: @escaping Intercept) {
        self.queue.append(action)
    }
    
    internal func intercept() {
        DispatchQueue.main.async {
            let intercept: Intercept = self.queue.removeFirst()
            intercept()
        }
    }
}
