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
    var version: String {
        return String(format: "%@ (%@)", self.appVersion, self.buildVersion)
    }
    
    var appVersion: String {
        return self.info(for: "CFBundleShortVersionString", or: "0.0.0")
    }
    
    var buildVersion: String {
        return self.info(for: "CFBundleVersion", or: "1")
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
    
    func info(for key: String,
              or default: String = "") -> String! {
        let value: String? = self.object(forInfoDictionaryKey: key) as? String
        return value ?? ""
    }
}
