//
//  DemoAnalyticsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnalytics
import FormsToastKit
import FormsUtils
import UIKit

// MARK: DemoAnalyticsViewController
class DemoAnalyticsViewController: FormsTableViewController {
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
        self.logEventButton.onClick = Unowned(self) { (_self) in
            Analytics.log(DemoAnalytics.DemoEvent.demoEvent(email: "some@email.com", value: 12))
            Toast.success()
                .with(title: "Logged")
                .show(in: _self.navigationController)
        }
    }
}

// MARK: DemoAnalytics
private enum DemoAnalytics {
    enum DemoEvent: AnalyticsEvent {
        case demoEvent(email: String, value: Int)
            
        var name: String {
            switch self {
            case .demoEvent: return "demo_event"
            }
        }
        var parameters: [String: Any?] {
            switch self {
            case .demoEvent(_, let value):
                return ["value": NSNumber(value: value)]
            }
        }
        var userProperties: [String: String?] {
            switch self {
            case .demoEvent(let email, _):
                return ["email": email]
            }
        }
    }
}
