//
//  Analytics.swift
//  FormsAnalytics
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseAnalytics
import FirebaseCore
import FormsInjector
import FormsLogger

public typealias AnalyticsEventParameters = [String: Any?]
public typealias AnalyticsEventUserProperties = [String: String?]

// MARK: AnalyticsTag
public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: AnalyticsEventParameters { get }
    var userProperties: AnalyticsEventUserProperties { get }
}

// MARK: AnalyticsProvider
public protocol AnalyticsProvider {
    var name: String { get }
    
    func logEvent(_ event: AnalyticsEvent,
                  _ parameters: [String: Any],
                  _ userProperties: [String: String])
    func setUserId(_ userId: String?)
}

// MARK: Analytics
public enum Analytics {
    private static var providers: [AnalyticsProvider] = []
        
    public static func register(_ provider: AnalyticsProvider) {
        Self.register([provider])
    }
    
    public static func register(_ providers: [AnalyticsProvider]) {
        for provider in providers {
            Self.providers.append(provider)
        }
    }
    
    public static func log(_ event: AnalyticsEvent) {
        guard event.name.count <= 40 else {
            let logger: Logger? = Injector.main.resolveOrDefault("FormsAnalytics")
            logger?.log(.warning, "----------\n----------\n\n\nTAG NAME ID TO LONG\n\n\n----------\n----------\n")
            return
        }
        
        let parameters: [String: Any] = event.parameters
            .reduce(into: [:], { $0[$1.key] = $1.value })
        let userProperties: [String: String] = event.userProperties
            .reduce(into: [:], { $0[$1.key] = $1.value })
        for provider in Self.providers {
            provider.logEvent(event, parameters, userProperties)
        }
    }
    
    public static func setUserId(_ userId: String?) {
        for provider in Self.providers {
            provider.setUserId(userId)
        }
    }
}
