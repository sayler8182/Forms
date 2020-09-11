//
//  AppStoreReview.swift
//  FormsAppStoreReview
//
//  Created by Konrad on 6/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import StoreKit

// MARK: StorageKey
public extension AppStoreReview {
    enum StorageKeys: String {
        case firstLaunchDate = "AppStoreReviewFirstLaunchDate"
        case launchCount = "AppStoreReviewLaunchCount"
        case lastReviewDate = "AppStoreReviewLastReviewDate"
    }
}

// MARK: AppStoreReviewProtocol
public protocol AppStoreReviewProtocol {
    @discardableResult
    func initFirstLaunchIfNeeded() -> Bool
    @discardableResult
    func launch() -> Bool
    @discardableResult
    func showIfNeeded() -> Bool
}

// MARK: AppStoreReview
public class AppStoreReview: AppStoreReviewProtocol {
    private let userDefaults = UserDefaults.standard
    private let minLaunchCount: Int
    private let minPeriod: TimeInterval
    private let minPeriodInterval: TimeInterval
    
    private var firstLaunchDate: Date? {
        get { return self.userDefaults.object(forKey: StorageKeys.firstLaunchDate.rawValue) as? Date }
        set {
            self.userDefaults.set(newValue, forKey: StorageKeys.firstLaunchDate.rawValue)
            self.userDefaults.synchronize()
        }
    }
    
    private var launchCount: Int {
        get { return (self.userDefaults.object(forKey: StorageKeys.launchCount.rawValue) as? Int) ?? 0 }
        set {
            self.userDefaults.set(newValue, forKey: StorageKeys.launchCount.rawValue)
            self.userDefaults.synchronize()
        }
    }
    
    private var lastReviewDate: Date? {
        get { return self.userDefaults.object(forKey: StorageKeys.lastReviewDate.rawValue) as? Date }
        set {
            self.userDefaults.set(newValue, forKey: StorageKeys.lastReviewDate.rawValue)
            self.userDefaults.synchronize()
        }
    }
    
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
