//
//  FormComponentState.swift
//  Forms
//
//  Created by Konrad on 6/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: FormsComponentStateType
public enum FormsComponentStateType {
    case active
    case selected
    case disabled
    case error
    case disabledSelected
    case loading
    
    var controlState: UIControl.State {
        switch self {
        case .active: return .normal
        case .selected: return .selected
        case .disabled: return .disabled
        case .error: return .normal
        case .disabledSelected: return .selected
        case .loading: return .normal
        }
    }
    var isEnabled: Bool {
        switch self {
        case .active: return true
        case .selected: return true
        case .disabled: return false
        case .error: return true
        case .disabledSelected: return false
        case .loading: return false
        }
    }
}

// MARK: FormsFormsComponentStateType
public protocol FormsFormsComponentStateType { }

// MARK: FormsComponentState
public protocol FormsComponentState {
    associatedtype T
    init()
}
    
// MARK: FormsComponentStateActive
public protocol FormsComponentStateActive: FormsComponentState {
    var active: T! { get set }
}
public extension FormsComponentStateActive {
    func with(active: T) -> Self {
        var `self` = self
        self.active = active
        return self
    }
}

// MARK: FormsComponentStateSelected
public protocol FormsComponentStateSelected: FormsComponentState {
    var selected: T! { get set }
}
public extension FormsComponentStateSelected {
    func with(selected: T) -> Self {
        var `self` = self
        self.selected = selected
        return self
    }
}

// MARK: FormsComponentStateDisabled
public protocol FormsComponentStateDisabled: FormsComponentState {
    var disabled: T! { get set }
}
public extension FormsComponentStateDisabled {
    func with(disabled: T) -> Self {
        var `self` = self
        self.disabled = disabled
        return self
    }
}

// MARK: FormsComponentStateError
public protocol FormsComponentStateError: FormsComponentState {
    var error: T! { get set }
}
public extension FormsComponentStateError {
    func with(error: T) -> Self {
        var `self` = self
        self.error = error
        return self
    }
}

// MARK: FormsComponentStateDisabledSelected
public protocol FormsComponentStateDisabledSelected: FormsComponentState {
    var disabledSelected: T! { get set }
}
public extension FormsComponentStateDisabledSelected {
    func with(disabledSelected: T) -> Self {
        var `self` = self
        self.disabledSelected = disabledSelected
        return self
    }
}

// MARK: FormsComponentStateLoading
public protocol FormsComponentStateLoading: FormsComponentState {
    var loading: T! { get set }
}
public extension FormsComponentStateLoading {
    func with(loading: T) -> Self {
        var `self` = self
        self.loading = loading
        return self
    }
}

// MARK: FormsComponentStateActiveSelectedDisabled
public protocol FormsComponentStateActiveSelectedDisabled: FormsComponentStateActive, FormsComponentStateSelected, FormsComponentStateDisabled { }
public extension FormsComponentStateActiveSelectedDisabled {
    init(_ value: T) {
        self.init()
        self.active = value
        self.selected = value
        self.disabled = value
    }
    
    func value(for state: FormsComponentStateType) -> T {
        switch state {
        case .active: return self.active
        case .selected: return self.selected
        case .disabled: return self.disabled
        default: return self.active
        }
    }
}

// MARK: FormsComponentStateActiveSelectedDisabledError
public protocol FormsComponentStateActiveSelectedDisabledError: FormsComponentStateActive, FormsComponentStateSelected, FormsComponentStateDisabled, FormsComponentStateError { }
public extension FormsComponentStateActiveSelectedDisabledError {
    init(_ value: T) {
        self.init()
        self.active = value
        self.selected = value
        self.disabled = value
        self.error = value
    }
     
    func value(for state: FormsComponentStateType) -> T {
        switch state {
        case .active: return self.active
        case .selected: return self.selected
        case .disabled: return self.disabled
        case .error: return self.error
        default: return self.active
        }
    }
}

// MARK: FormsComponentStateActiveSelectedDisabledDisabledSelected
public protocol FormsComponentStateActiveSelectedDisabledDisabledSelected: FormsComponentStateActive, FormsComponentStateSelected, FormsComponentStateDisabled, FormsComponentStateDisabledSelected { }
public extension FormsComponentStateActiveSelectedDisabledDisabledSelected {
    init(_ value: T) {
        self.init()
        self.active = value
        self.selected = value
        self.disabled = value
        self.disabledSelected = value
    }
     
    func value(for state: FormsComponentStateType) -> T {
        switch state {
        case .active: return self.active
        case .selected: return self.selected
        case .disabled: return self.disabled
        case .disabledSelected: return self.disabledSelected
        default: return self.active
        }
    }
}

// MARK: FormsComponentStateActiveSelectedDisabledLoading
public protocol FormsComponentStateActiveSelectedDisabledLoading: FormsComponentStateActive, FormsComponentStateSelected, FormsComponentStateDisabled, FormsComponentStateLoading { }
public extension FormsComponentStateActiveSelectedDisabledLoading {
    init(_ value: T) {
        self.init()
        self.active = value
        self.selected = value
        self.disabled = value
        self.loading = value
    }
     
    func value(for state: FormsComponentStateType) -> T {
        switch state {
        case .active: return self.active
        case .selected: return self.selected
        case .disabled: return self.disabled
        case .loading: return self.loading
        default: return self.active
        }
    }
}

// MARK: UIColor
public extension FormsComponentStateActiveSelectedDisabled where T == UIColor? {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value?.with(alpha: 0.7)
        self.disabled = Theme.Colors.gray
    }
}
public extension FormsComponentStateActiveSelectedDisabledError where T == UIColor? {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value?.with(alpha: 0.7)
        self.disabled = Theme.Colors.gray
        self.error = Theme.Colors.red
    }
}
public extension FormsComponentStateActiveSelectedDisabledDisabledSelected where T == UIColor? {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value?.with(alpha: 0.7)
        self.disabled = Theme.Colors.gray
        self.disabledSelected = value?.with(alpha: 0.7)
    }
}

public extension FormsComponentStateActiveSelectedDisabledLoading where T == UIColor? {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value?.with(alpha: 0.7)
        self.disabled = Theme.Colors.gray
        self.loading = value
    }
}

// MARK: [UIColor]
public extension FormsComponentStateActiveSelectedDisabled where T == [UIColor?] {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value.map { $0?.with(alpha: 0.7) }
        self.disabled = [Theme.Colors.gray, Theme.Colors.gray]
    }
}
public extension FormsComponentStateActiveSelectedDisabledError where T == [UIColor?] {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value.map { $0?.with(alpha: 0.7) }
        self.disabled = [Theme.Colors.gray, Theme.Colors.gray]
        self.error = [Theme.Colors.red, Theme.Colors.red]
    }
}
public extension FormsComponentStateActiveSelectedDisabledDisabledSelected where T == [UIColor?] {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value.map { $0?.with(alpha: 0.7) }
        self.disabled = [Theme.Colors.gray, Theme.Colors.gray]
        self.disabledSelected = value.map { $0?.with(alpha: 0.7) }
    }
}

public extension FormsComponentStateActiveSelectedDisabledLoading where T == [UIColor?] {
    init(default value: T) {
        self.init()
        self.active = value
        self.selected = value.map { $0?.with(alpha: 0.7) }
        self.disabled = [Theme.Colors.gray, Theme.Colors.gray]
        self.loading = value
    }
}
