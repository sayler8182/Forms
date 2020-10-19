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
            component.locale = Locale(identifier: "en_GB")
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
            component.locale = Locale(identifier: "en_GB")
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
            component.locale = Locale(identifier: "en_GB")
            if #available(iOS 13.4, *) {
                component.preferredDatePickerStyle = .wheels
            }
            return component
        }
    }
    public enum range {
        public enum date {
            public static func `default`() -> DateRangePicker {
                let component = DateRangePicker()
                component.datePickerMode = .date
                component.locale = Locale(identifier: "en_GB")
                if #available(iOS 13.4, *) {
                    component.preferredDatePickerStyle = .compact
                }
                return component
            }
        }
        public enum time {
            public static func `default`() -> DateRangePicker {
                let component = DateRangePicker()
                component.datePickerMode = .time
                component.locale = Locale(identifier: "en_GB")
                if #available(iOS 13.4, *) {
                    component.preferredDatePickerStyle = .compact
                }
                return component
            }
        }
        public enum dateAndTime {
            public static func `default`() -> DateRangePicker {
                let component = DateRangePicker()
                component.datePickerMode = .dateAndTime
                component.locale = Locale(identifier: "en_GB")
                if #available(iOS 13.4, *) {
                    component.preferredDatePickerStyle = .compact
                }
                return component
            }
        }
    }
}
