//
//  EventBus.swift
//  FormsUtils
//
//  Created by Konrad on 10/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import Foundation

// MARK: EventBusProtocol
public protocol EventBusProtocol: class {
    var observers: [String: [WeakEventBusObserver]] { get set }
    
    func register(_ events: [EventBusKeys])
    func register(_ event: EventBusKeys)
    func unregister(_ events: [EventBusKeys])
    func unregister(_ event: EventBusKeys)
    func sendEvent(_ event: EventBusKeys,
                   _ parameters: Any?)
    
    func observers(`for` key: String,
                   target: AnyObject?) -> [WeakEventBusObserver]?
}

// MARK: EventBusKey
public protocol EventBusKeys {
    var rawValue: String { get }
}

// MARK: EventBusKeys
public extension EventBusKeys {
    var name: NSNotification.Name {
        return NSNotification.Name(self.rawValue)
    }
}

// MARK: EventBus
public class EventBus: EventBusProtocol {
    private let queue: DispatchQueue = .global()
    private var notificationCenter = NotificationCenter()
    
    public var _observers: [String: [WeakEventBusObserver]] = [:]
    public var observers: [String: [WeakEventBusObserver]] {
        get { return self.queue.sync { self._observers } }
        set { self.queue.sync { self._observers = newValue } }
    }
    
    public init() { }
    
    public func register(_ events: [EventBusKeys]) {
        for event in events {
            self.register(event)
        }
    }
    
    public func register(_ event: EventBusKeys) {
        _ = self.notificationCenter.addObserver(
            forName: event.name,
            object: nil,
            queue: .main,
            using: { [weak self] (notification: Notification) in
                guard let `self` = self else { return }
                self.receiveEvent(event, notification.object)
            })
    }
    
    public func unregister(_ events: [EventBusKeys]) {
        for event in events {
            self.unregister(event)
        }
    }
    
    public func unregister(_ event: EventBusKeys) {
        self.notificationCenter.removeObserver(
            self,
            name: event.name,
            object: nil)
    }
    
    public func sendEvent(_ event: EventBusKeys,
                          _ parameters: Any?) {
        self.notificationCenter.post(name: event.name, object: parameters)
    }
    
    public func receiveEvent(_ event: EventBusKeys,
                             _ parameters: Any?) {
        let observers = self.observers[event.rawValue] ?? []
        for observer in observers {
            observer.value?.receiveEvent(event, parameters)
        }
    }
    
    public func observers(`for` key: String,
                          target: AnyObject?) -> [WeakEventBusObserver]? {
        let observers: [String: [WeakEventBusObserver]] = self.observers
        return self.queue.sync {
            observers[key]?.filter { $0.value !== target }
        }
    }
}

// MARK: EventBusObserver
public protocol EventBusObserver: class {
    var bus: EventBusProtocol { get }
    
    func registerEvent(_ event: EventBusKeys)
    func unregisterEvent(_ event: EventBusKeys)
    func clearEvents()
    
    func sendEvent(_ event: EventBusKeys,
                   _ parameters: Any?)
    func receiveEvent(_ event: EventBusKeys,
                      _ parameters: Any?)
}

// MARK: EventBusObserver
public extension EventBusObserver {
    var bus: EventBusProtocol {
        return Injector.main.resolve()
    }
    
    func registerEvent(_ event: EventBusKeys) {
        self.unregisterEvent(event)
        var observers = self.bus.observers[event.rawValue] ?? []
        observers.append(WeakEventBusObserver(self))
        self.bus.observers[event.rawValue] = observers
    }
    
    func unregisterEvent(_ event: EventBusKeys) {
        self.bus.observers[event.rawValue] = self.bus.observers(for: event.rawValue, target: self)
        self.clearEvents()
    }
    
    func clearEvents() {
        for key in self.bus.observers.keys {
            self.bus.observers[key] = self.bus.observers(for: key, target: nil)
        }
    }
    
    func sendEvent(_ event: EventBusKeys,
                   _ parameters: Any?) {
        self.bus.sendEvent(event, parameters)
    }
}

// MARK: WeakEventBusObserver
public class WeakEventBusObserver {
    private weak var _value: EventBusObserver?
    public var value: EventBusObserver? {
        get { return self._value }
        set { self._value = newValue }
    }
    
    init(_ value: EventBusObserver?) {
        self._value = value
    }
}
