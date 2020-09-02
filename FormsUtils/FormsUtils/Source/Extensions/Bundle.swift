//
//  Bundle.swift
//  FormsUtils
//
//  Created by Konrad on 8/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Bundle
public extension Bundle {
    var fullVersion: String {
        return String(format: "%@ (%@)", self.appVersion, self.buildVersion)
    }
    
    var appVersion: String {
        return self.info(for: "CFBundleShortVersionString", or: "0.0.0")
    }
    
    var buildVersion: String {
        return self.info(for: "CFBundleVersion", or: "1")
    }
    
    var buildDate: Date? {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist") else { return nil }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) else { return nil }
        return attributes[.creationDate] as? Date
    }
    
    var iOSBundle: String {
        return self.info(for: "CFBundleIdentifier")
    }
    
    var targetName: String {
        return self.info(for: "CFBundleName")
    }
    
    var storeIdentifier: String {
        return self.info(for: "SKStoreProductParameterITunesItemIdentifier")
    }
    
    func decode<T: Decodable>(_ type: T.Type,
                              from filename: String,
                              with decoder: JSONDecoder? = nil) -> T? {
        guard let url: URL = self.url(forResource: filename, withExtension: nil) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder: JSONDecoder = decoder ?? JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    func info(for key: String,
              or default: String = "") -> String! {
        let value: String? = self.object(forInfoDictionaryKey: key) as? String
        return value ?? ""
    }
}
