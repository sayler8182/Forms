//
//  DemoAnalyticsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(Analytics)

import Analytics
import Forms
import UIKit

// MARK: DemoAnalyticsViewController
class DemoAnalyticsViewController: TableViewController {
    private let logEventButton = Components.button.default()
        .with(title: "Log event")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.logEventButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.logEventButton.onClick = {
            Analytics.log(DemoAnalytics.DemoEvent.demoEvent, [
                DemoAnalytics.DemoEvent.Parameter.demoParameter(value: "value")
            ])
        }
    }
}

// MARK: DemoAnalytics
private enum DemoAnalytics {
    enum DemoEvent: String, AnalyticsTag {
        case demoEvent = "demo_event"
        
        enum Parameter: AnalyticsTagParameter {
            case demoParameter(value: String)
            
            var parameters: [String: Any?] {
                switch self {
                case .demoParameter(let value):
                    return ["value": value]
                }
            }
            var userProperties: [String: String?] {
                switch self {
                case .demoParameter(let value):
                    return ["value": value]
                }
            }
        }
    }
}

#endif
