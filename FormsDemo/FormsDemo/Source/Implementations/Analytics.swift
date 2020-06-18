//
//  Analytics.swift
//  FormsDemo
//
//  Created by Konrad on 6/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FBSDKCoreKit
import FirebaseAnalytics
import FormsAnalytics
import FormsLogger
import Foundation

// MARK: DemoAnalyticsCustomProvider
public class DemoAnalyticsCustomProvider: AnalyticsProvider {
    public let name: String = "Custom"
    
    private let logger = ConsoleLogger(whitelist: CustomLogType.allCases)
    
    public init() { }
    
    public func logEvent(_ event: AnalyticsEvent,
                         _ parameters: [String: Any],
                         _ userProperties: [String: String]) {
        var log: String = "LogEvent - \(event.name):"
        if !userProperties.isEmpty {
            log += "\n UserProperties"
            for userProperty in userProperties {
                log += "\n  - " + userProperty.key + " : " + userProperty.value
            }
        }
        if !parameters.isEmpty {
            log += "\n Parameters"
            for parameter in parameters {
                log += "\n  - " + parameter.key + " : " + "\(parameter.value)"
            }
        }
        self.logger.log(CustomLogType.info, log)
    }
    
    public func setUserId(_ userId: String?) {
        let log: String = "User Id: \(userId.or(""))"
        self.logger.log(CustomLogType.info, log)
    }
}

// MARK: DemoAnalyticsFacebookProvider
public class DemoAnalyticsFacebookProvider: AnalyticsProvider {
    public let name: String = "Facebook"
    
    public init() { }
    
    public func logEvent(_ event: AnalyticsEvent,
                         _ parameters: [String: Any],
                         _ userProperties: [String: String]) {
        for userProperty in userProperties {
            FBSDKCoreKit.AppEvents.setUserData(
                userProperty.value,
                forType: AppEvents.UserDataType(userProperty.key))
        }
        FBSDKCoreKit.AppEvents.logEvent(
            FBSDKCoreKit.AppEvents.Name(event.name),
            parameters: parameters
        )
    }
    
    public func setUserId(_ userId: String?) {
        FBSDKCoreKit.AppEvents.userID = userId
    }
}

// MARK: DemoAnalyticsFirebaseProvider
public class DemoAnalyticsFirebaseProvider: AnalyticsProvider {
    public let name: String = "Firebase"
    
    public init() { }
    
    public func logEvent(_ event: AnalyticsEvent,
                         _ parameters: [String: Any],
                         _ userProperties: [String: String]) {
        for userProperty in userProperties {
            FirebaseAnalytics.Analytics.setUserProperty(
                userProperty.value,
                forName: userProperty.key)
        }
        FirebaseAnalytics.Analytics.logEvent(
            event.name,
            parameters: parameters)
    }
    
    public func setUserId(_ userId: String?) {
        FirebaseAnalytics.Analytics.setUserID(userId)
    }
}
