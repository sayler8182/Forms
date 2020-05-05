//
//  DeveloperTools.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DeveloperFeatureKey
public protocol DeveloperFeatureKey {
    var rawValue: String { get }
    var rawKey: String { get }
    var title: String { get }
    var isEnabled: Bool { get }
}

public extension DeveloperFeatureKey {
    var rawKey: String {
        return "developer.tools" + self.rawValue
    }
    var isEnabled: Bool {
        return true
    }
}

// MARK: DeveloperFeatureFlagKey
public protocol DeveloperFeatureFlagKey: DeveloperFeatureKey { }

// MARK: DeveloperFeatures
public struct DeveloperFeatures {
    public var features: [DeveloperFeatureKey] = []
    public var featuresFlags: [DeveloperFeatureFlagKey] = []
}

// MARK: DeveloperToolsNotification
private enum DeveloperToolsNotification {
    static let shakeMotion = NSNotification.Name("developer.tools.notification.shake.motion")
}

// MARK: DeveloperToolsAppVersion
public struct DeveloperToolsAppVersion {
    public let shortVersion: String
    public let buildVersion: String
    public let bundleId: String
    public let buildDate: String
    
    public var fullVersion: String {
        return [self.shortVersion, self.buildVersion].filter { !$0.isEmpty }.joined(separator: ".")
    }
    
    init() {
        let bundle: Bundle = Bundle.main
        self.shortVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        self.buildVersion = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        self.bundleId = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
        self.buildDate = bundle.object(forInfoDictionaryKey: "CFBuildDate") as? String ?? ""
    }
}

// MARK: DeveloperTools
public class DeveloperTools: NSObject {
    private static var viewType: (UIViewController & DeveloperToolsMenu).Type = DeveloperToolsMenuViewController.self
    private static var features: DeveloperFeatures = DeveloperFeatures()
    private static var onSelect: DeveloperToolsMenu.OnSelect?
    
    @available(iOS 13.0, *)
    internal static var scene: UIWindowScene! {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    public static var newWindow: UIWindow {
        if #available(iOS 13.0, *) {
            return UIWindow(windowScene: Self.scene)
        } else {
            return UIWindow(frame: UIScreen.main.bounds)
        }
    }
    
    private static var window: UIWindow = {
        let window = DeveloperTools.newWindow
        window.windowLevel = UIWindow.Level.statusBar - 1
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        window.isHidden = true
        return window
    }()
    public static let appVersion: DeveloperToolsAppVersion = DeveloperToolsAppVersion()
    
    public static subscript(_ key: DeveloperFeatureFlagKey) -> Bool {
        get { return (UserDefaults.standard.object(forKey: key.rawKey) as? Bool) ?? key.isEnabled }
        set { UserDefaults.standard.set(newValue, forKey: key.rawKey) }
    }
    
    public static func configure(features: [DeveloperFeatureKey],
                                 featuresFlags: [DeveloperFeatureFlagKey],
                                 viewType: (UIViewController & DeveloperToolsMenu).Type = DeveloperToolsMenuViewController.self,
                                 onSelect: DeveloperToolsMenu.OnSelect? = nil) {
        self.viewType = viewType
        self.features.features = features
        self.features.featuresFlags = featuresFlags
        self.onSelect = onSelect
        NotificationCenter.default.addObserver(
            Self.self,
            selector: #selector(showMenu),
            name: DeveloperToolsNotification.shakeMotion,
            object: nil)
    }
    
    @objc
    public static func showMenu() {
        guard self.window.isHidden else { return }
        self.window.isHidden = false
        let controller = self.viewType.init(
            features: self.features,
            onSelect: self.onSelect)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        self.window.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}

public extension UIWindow {
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        guard motion == .motionShake else { return }
        NotificationCenter.default.post(name: DeveloperToolsNotification.shakeMotion, object: nil)
    }
}
