//
//  LaunchOptions.swift
//  Forms
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

// MARK: LaunchOptionsProtocol
public protocol LaunchOptionsProtocol {
    var launchedURL: URL? { get }
    
    func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    @available(iOS 13.0, *)
    func launch(_ urlContexts: Set<UIOpenURLContext>)
    func launch(_ launchedURL: URL?)
    func handleIfNeeded(_ handle: (URL, [String: Any]) -> Void)
    func handleIfNeeded<T: Decodable>(_ handle: (URL, T?) -> Void)
}

// MARK: LaunchOptions
public class LaunchOptions: LaunchOptionsProtocol {
    private static var launchedURL: URL? = nil
    
    public init() { }
    
    public var launchedURL: URL? {
        return Self.launchedURL
    }
    
    public func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL
        self.launch(url)
    }
    
    @available(iOS 13.0, *)
    public func launch(_ urlContexts: Set<UIOpenURLContext>) {
        let url = urlContexts.first?.url
        self.launch(url)
    }
    
    public func launch(_ launchURL: URL?) {
        Self.launchedURL = launchURL
    }
    
    public func handleIfNeeded(_ handle: (URL, [String: Any]) -> Void) {
        guard let launchedURL: URL = Self.launchedURL else { return }
        let coder: URLCoder = URLCoder()
        let launchedParameters: [String: Any] = coder.decode(url: launchedURL)
        Self.launchedURL = nil
        handle(launchedURL, launchedParameters)
    }
    
    public func handleIfNeeded<T: Decodable>(_ handle: (URL, T?) -> Void) {
        guard let launchedURL: URL = Self.launchedURL else { return }
        let coder: URLCoder = URLCoder()
        let launchedObject: T? = coder.decode(url: launchedURL)
        Self.launchedURL = nil
        handle(launchedURL, launchedObject)
    }
}
