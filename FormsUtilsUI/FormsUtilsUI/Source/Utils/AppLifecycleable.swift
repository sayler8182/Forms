//
//  AppLifecycleable.swift
//  FormsUtils
//
//  Created by Konrad on 6/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: AppLifecycleEvent
public enum AppLifecycleEvent: String, Equatable {
    case didEnterBackground
    case willEnterForeground
    case didFinishLaunching
    case didBecomeActive
    case willResignActive
    case didReceiveMemoryWarning
    case willTerminate
    case significantTimeChange
    
    var name: NSNotification.Name {
        switch self {
        case .didEnterBackground: return UIApplication.didEnterBackgroundNotification
        case .willEnterForeground: return UIApplication.willEnterForegroundNotification
        case .didFinishLaunching: return UIApplication.didFinishLaunchingNotification
        case .didBecomeActive: return UIApplication.didBecomeActiveNotification
        case .willResignActive: return UIApplication.willResignActiveNotification
        case .didReceiveMemoryWarning: return UIApplication.didReceiveMemoryWarningNotification
        case .willTerminate: return UIApplication.willTerminateNotification
        case .significantTimeChange: return UIApplication.significantTimeChangeNotification
        }
    }
}

// MARK: AppLifecycle
public protocol AppLifecycleable: class {
    var appLifecycleableEvents: [AppLifecycleEvent] { get }
    
    func appLifecycleable(event: AppLifecycleEvent)
}

public extension AppLifecycleable {
    func registerAppLifecycle() {
        let events: [AppLifecycleEvent] = self.appLifecycleableEvents
        for event in events {
            self.register(event)
        }
    }
    
    func unregisterAppLifecycle() {
        let events: [AppLifecycleEvent] = self.appLifecycleableEvents
        guard events.isNotEmpty else { return }
        for event in events {
            self.unregister(event)
        }
    }
     
    private func register(_ event: AppLifecycleEvent) {
        _ = NotificationCenter.default.addObserver(
            forName: event.name,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let `self` = self else { return }
                self.appLifecycleable(event: event)
        })
    }
    
    private func unregister(_ event: AppLifecycleEvent) {
        NotificationCenter.default.removeObserver(
            self,
            name: event.name,
            object: nil)
    }
}
