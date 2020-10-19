//
//  Dispatcher.swift
//  FormsUtils
//
//  Created by Konrad on 10/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Dispatcher
public class Dispatcher {
    private var group: DispatchGroup = DispatchGroup()
    public private (set) weak var parrent: Dispatcher? = nil
    public private (set) var isProccessing: Bool = false
    public private (set) var cancelTokens: [CancelToken] = []
    
    public init(_ parrent: Dispatcher? = nil) {
        self.parrent = parrent
    }
    
    public func enter() {
        guard !self.isProccessing else { return }
        self.isProccessing = true
        self.group.enter()
    }
    
    public func leave() {
        guard self.isProccessing else { return }
        self.isProccessing = false
        self.group.leave()
    }
    
    public func wait() {
        self.wait(nil, nil, nil)
    }
    
    public func wait(_ completion: (() -> Void)?) {
        self.wait(nil, nil, completion)
    }
    
    public func wait(_ cancelToken: CancelToken?,
                     _ completion: (() -> Void)? = nil) {
        self.wait(nil, cancelToken, completion)
    }
    
    public func wait(_ queue: DispatchQueue?,
                     _ cancelToken: CancelToken? = nil,
                     _ completion: (() -> Void)? = nil) {
        self.appendCancelToken(cancelToken)
        self.parrent?.wait(cancelToken)
        self.group.wait()
        if cancelToken?.isCancelled != true,
           let completion = completion {
            if let queue: DispatchQueue = queue {
                queue.async { completion() }
            } else {
                completion()
            }
        }
    }
    
    public func notify(queue: DispatchQueue,
                       work: DispatchWorkItem) {
        self.group.notify(queue: queue, work: work)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval) -> DispatchTimeoutResult {
        return self.wait(timeout, nil, nil, nil)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval,
                     _ completion: ((DispatchTimeoutResult) -> Void)? = nil) -> DispatchTimeoutResult {
        return self.wait(timeout, nil, nil, completion)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval,
                     _ cancelToken: CancelToken?,
                     _ completion: ((DispatchTimeoutResult) -> Void)? = nil) -> DispatchTimeoutResult {
        return self.wait(timeout, nil, cancelToken, completion)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval,
                     _ queue: DispatchQueue?,
                     _ cancelToken: CancelToken? = nil,
                     _ completion: ((DispatchTimeoutResult) -> Void)? = nil) -> DispatchTimeoutResult {
        self.appendCancelToken(cancelToken)
        self.parrent?.wait(cancelToken)
        let result = self.group.wait(timeout)
        if cancelToken?.isCancelled != true,
           let completion = completion {
            if let queue: DispatchQueue = queue {
                queue.async { completion(result) }
            } else {
                completion(result)
            }
        }
        return result
    }
    
    public func reset() {
        self.cancelTokens.forEach({ $0.cancel() })
        self.leave()
        self.group = DispatchGroup()
    }
    
    public func resetIfNeeded() {
        guard self.cancelTokens.isNotEmpty else { return }
        self.reset()
    }
    
    private func appendCancelToken(_ cancelToken: CancelToken?) {
        guard let cancelToken: CancelToken = cancelToken else { return }
        self.cancelTokens.append(cancelToken)
    }
}
