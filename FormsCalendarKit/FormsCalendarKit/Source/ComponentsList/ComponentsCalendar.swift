//
//  ComponentsCalendar.swift
//  FormsCalendarKit
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

public enum ComponentsCalendar: ComponentsList {
    public static func calendar() -> CalendarView {
        let component = CalendarView()
        component.batchUpdate({
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.dayColors = CalendarMonthView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                component.dayFonts = CalendarMonthView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                    .with(selected: Theme.Fonts.bold(ofSize: 12))
                    .with(disabledSelected: Theme.Fonts.bold(ofSize: 12))
                component.monthColor = Theme.Colors.primaryDark
                component.monthFont = Theme.Fonts.regular(ofSize: 12)
                component.tintColors = CalendarMonthView.State<UIColor?>(Theme.Colors.tertiaryLight)
                    .with(disabled: Theme.Colors.tertiaryDark.with(alpha: 0.7))
                component.weekTitleColor = Theme.Colors.tertiaryDark
                component.weekTitleFont = Theme.Fonts.regular(ofSize: 12)
            }
        }, component.reloadData)
        return component
    }
    
    public static func month() -> CalendarMonthView {
        let component = CalendarMonthView()
        component.batchUpdate({
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.tintColors = CalendarMonthView.State<UIColor?>(Theme.Colors.tertiaryLight)
                    .with(disabled: Theme.Colors.tertiaryDark.with(alpha: 0.7))
                component.titleColors = CalendarMonthView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                component.titleFonts = CalendarMonthView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                    .with(selected: Theme.Fonts.bold(ofSize: 12))
                    .with(disabledSelected: Theme.Fonts.bold(ofSize: 12))
            }
        }, component.remakeContentView)
        return component
    }
        
    public static func week() -> CalendarWeekView {
        let component = CalendarWeekView()
        component.batchUpdate({
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColor = Theme.Colors.primaryLight
                component.titleColor = Theme.Colors.tertiaryDark
                component.titleFont = Theme.Fonts.regular(ofSize: 12)
            }
        }, component.remakeContentView)
        return component
    }
    
    public static func monthWithWeek() -> CalendarMonthWithWeekView {
        let component = CalendarMonthWithWeekView()
        component.batchUpdate({
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.tintColors = CalendarMonthView.State<UIColor?>(Theme.Colors.tertiaryLight)
                    .with(disabled: Theme.Colors.tertiaryDark.with(alpha: 0.7))
                component.titleColors = CalendarMonthView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                component.titleFonts = CalendarMonthView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                    .with(selected: Theme.Fonts.bold(ofSize: 12))
                    .with(disabledSelected: Theme.Fonts.bold(ofSize: 12))
                component.weekTitleColor = Theme.Colors.tertiaryDark
                component.weekTitleFont = Theme.Fonts.regular(ofSize: 12)
            }
        }, component.remakeContentView)
        return component
    }
}
