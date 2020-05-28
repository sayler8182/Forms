//
//  FormsIntegrationAnalyticsViewController.swift
//  FormsIntegration
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnalytics
import UIKit

// MARK: FormsIntegrationAnalyticsViewController
class FormsIntegrationAnalyticsViewController: FormsTableViewController {
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
        self.logEventButton.onClick = { [unowned self] in
            Analytics.log(IntegrationAnalytics.IntegrationEvent.integrationEvent, [
                IntegrationAnalytics.IntegrationEvent.Parameter.integrationParameter(value: "value")
            ])
            Toast.success()
                .with(title: "Logged")
                .show(in: self.navigationController)
        }
    }
}

// MARK: IntegrationAnalytics
private enum IntegrationAnalytics {
    enum IntegrationEvent: String, AnalyticsTag {
        case integrationEvent = "integration_event"
        
        enum Parameter: AnalyticsTagParameter {
            case integrationParameter(value: String)
            
            var parameters: [String: Any?] {
                switch self {
                case .integrationParameter(let value):
                    return ["value": value]
                }
            }
            var userProperties: [String: String?] {
                switch self {
                case .integrationParameter(let value):
                    return ["value": value]
                }
            }
        }
    }
}
