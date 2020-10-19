//
//  CancelToken.swift
//  FormsUtils
//
//  Created by Konrad on 10/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: CancelToken
public class CancelToken {
    private let queue: DispatchQueue = DispatchQueue.global()
    
    public var _isCancelled: Bool = false
    public var isCancelled: Bool {
        get { return self.queue.sync { self._isCancelled } }
        set { self.queue.sync { self._isCancelled = newValue } }
    }
    
    public static var new: CancelToken {
        return CancelToken()
    }
    
    public init() { }
    
    public func cancel() {
        self.isCancelled = true
    }
}
