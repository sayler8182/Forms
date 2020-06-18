//
//  Debouncer.swift
//  FormsUtils
//
//  Created by Konrad on 6/18/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Debouncer
public class Debouncer {
    public typealias Debounce = () -> Void
    
    private let interval: TimeInterval
    private var timer: Timer?
    private (set) var onHandle: Debounce?
    
    public init(interval: TimeInterval) {
        self.interval = interval
    }
    
    public func debounce(_ onHandle: @escaping Debounce) {
        self.onHandle = onHandle
        self.debounce()
    }
        
    public func debounce() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: self.interval,
            repeats: false,
            block: { [weak self] _ in
                guard let `self` = self else { return }
                self.handleDebounce()
        })
    }
    
    @objc
    public func handleDebounce() {
        self.timer?.invalidate()
        self.onHandle?()
        self.onHandle = nil
    }
}
