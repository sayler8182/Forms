//
//  AppStoreReview.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import StoreKit

// MARK: StorageKey
private extension AppStoreReview {
    enum StorageKeys: String, StorageKey {
        case firstLaunchDate = "StoreReviewFirstLaunchDate"
        case launchCount = "StoreReviewLaunchCount"
        case lastReviewDate = "StoreReviewLastReviewDate"
    }
}

// MARK: AppStoreReview
public class AppStoreReview {
    private let minLaunchCount: Int
    private let minPeriod: TimeInterval
    private let minPeriodInterval: TimeInterval
    
    @Storage(StorageKeys.firstLaunchDate)
    private var firstLaunchDate: Date? // swiftlint:disable:this let_var_whitespace
    
    @StorageWithDefault(StorageKeys.launchCount, 0)
    private var launchCount: Int // swiftlint:disable:this let_var_whitespace
    
    @Storage(StorageKeys.lastReviewDate)
    private var lastReviewDate: Date? // swiftlint:disable:this let_var_whitespace
    
    private var isMinLaunchCountAchived: Bool {
        return self.minLaunchCount <= self.launchCount
    }
    
    private var isMinPeriodAchived: Bool {
        guard let firstLaunchDate: Date = self.firstLaunchDate else { return false }
        return firstLaunchDate.addingTimeInterval(self.minPeriod) <= Date()
    }
    
    private var isMinPeriodIntervalAchived: Bool {
        guard let lastReviewDate: Date = self.lastReviewDate else { return true }
        return lastReviewDate.addingTimeInterval(self.minPeriodInterval) <= Date()
    }
    
    public init(minLaunchCount: Int = 3,
                minPeriod: TimeInterval = 0,
                minPeriodInterval: TimeInterval = 60 * 60 * 24 * 30) {
        self.minLaunchCount = minLaunchCount
        self.minPeriod = minPeriod
        self.minPeriodInterval = minPeriodInterval
    }
    
    @discardableResult
    public func initFirstLaunchIfNeeded() -> Bool {
        guard self.firstLaunchDate == nil else { return false }
        self.firstLaunchDate = Date()
        return true
    }
    
    @discardableResult
    public func launch() -> Bool {
        self.launchCount += 1
        return true
    }
    
    @discardableResult
    public func showIfNeeded() -> Bool {
        if #available(iOS 10.3, *) {
            if self.isMinLaunchCountAchived && self.isMinPeriodAchived && self.isMinPeriodIntervalAchived {
                SKStoreReviewController.requestReview()
                self.lastReviewDate = Date()
                return true
            }
        }
        return false
    }
}
