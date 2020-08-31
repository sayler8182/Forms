//
//  ComponentsDates.swift
//  Forms
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public enum ComponentsDates: ComponentsList {
    public enum date {
        public static func `default`() -> DatePicker {
            let component = DatePicker()
            component.datePickerMode = .date
            if #available(iOS 13.4, *) {
                component.preferredDatePickerStyle = .wheels
            }
            return component
        }
    }
    public enum time {
        public static func `default`() -> DatePicker {
            let component = DatePicker()
            component.datePickerMode = .time
            if #available(iOS 13.4, *) {
                component.preferredDatePickerStyle = .wheels
            }
            return component
        }
    }
    public enum dateAndTime {
        public static func `default`() -> DatePicker {
            let component = DatePicker()
            component.datePickerMode = .dateAndTime
            if #available(iOS 13.4, *) {
                component.preferredDatePickerStyle = .wheels
            }
            return component
        }
    }
}
