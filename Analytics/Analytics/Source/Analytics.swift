//
//  Analytics.swift
//  Analytics
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseCore
import FirebaseAnalytics

// MARK: AnalyticsTag
public protocol AnalyticsTag {
    var rawValue: String { get }
}

// MARK: AnalyticsTagParameter
public protocol AnalyticsTagParameter {
    var parameters: [String: Any?] { get }
    var userProperties: [String: String?] { get }
}

// MARK: Analytics
public enum Analytics {
    public static func configure() {
        FirebaseApp.configure()
    }
    
    public static func log(_ tag: AnalyticsTag,
                           _ parameters: [AnalyticsTagParameter] = []) {
        guard tag.rawValue.count <= 40 else {
            print("----------\n----------\n\n\nTAG NAME ID TO LONG\n\n\n----------\n----------\n")
            return
        }
        
        let _parameters: [String: Any] = parameters
            .flatMap { $0.parameters }
            .reduce(into: [:], { $0[$1.key] = $1.value })
        let _userProperties: [String: String] = parameters
            .flatMap { $0.userProperties }
            .reduce(into: [:], { $0[$1.key] = $1.value })
        
        // firebase
        for userProperty in _userProperties {
            FirebaseAnalytics.Analytics.setUserProperty(
                userProperty.value,
                forName: userProperty.key)
        }
        FirebaseAnalytics.Analytics.logEvent(
            tag.rawValue,
            parameters: _parameters)
    }
    
    // set user id
    public static func setUserID(_ userID: String?) {
        FirebaseAnalytics.Analytics.setUserID(userID)
    }
}
