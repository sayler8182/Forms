//
//  Logger.swift
//  FormsLogger
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import os.log

// MARK: Logger
public protocol Logger {
    func log(_ type: LogTypeProtocol,
             _ item: Any)
}

// MARK: LogTypeProtocol
public protocol LogTypeProtocol {
    var rawValue: String { get }
}

// MARK: LogType
public enum LogType: String, CaseIterable, LogTypeProtocol {
    case info = "_info"
    case warning = "_warning"
    case error = "_error"
}

// MARK: ConsoleLogger
public class ConsoleLogger: Logger {
    public let whitelist: [LogTypeProtocol]
    
    public init(whitelist: [LogTypeProtocol]) {
        self.whitelist = whitelist
    }
    
    public init() {
        self.whitelist = LogType.allCases
    }
    
    public func log(_ type: LogTypeProtocol,
                    _ item: Any) {
        guard self.shouldLog(type) else { return }
        self.logConsole(item)
        self.logSystem(item)
    }
    
    internal func shouldLog(_ type: LogTypeProtocol) -> Bool {
        let result: Bool = self.whitelist
            .map { $0.rawValue }
            .contains(type.rawValue)
        return result
    }
    
    internal func logConsole(_ item: Any) {
        print(item)
    }
    
    internal func logSystem(_ item: Any) {
        let string: String = "\(item)"
        let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "com.limbo.Forms.Logger"
        let log: OSLog = OSLog(subsystem: bundleIdentifier, category: "logger")
        #if DEBUG
        os_log("%{PUBLIC}@", log: log, type: .default, string)
        #else
        os_log("%{PRIVATE}@", log: log, type: .default, string)
        #endif
    }
}

// MARK: ConsoleOnlyLogger
public class ConsoleOnlyLogger: ConsoleLogger {
    override internal func logSystem(_ item: Any) { }
}

// MARK: SystemOnlyLogger
public class SystemOnlyLogger: ConsoleLogger {
    override internal func logConsole(_ item: Any) { }
}
