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
    func log(_ type: LogType,
             _ item: Any)
}

// MARK: LogType
public enum LogType: Int {
    case info = 0
    case warning = 1
    case error = 2
}

// MARK: ConsoleLogger
public class ConsoleLogger: Logger {
    public init() { }
    
    public func log(_ type: LogType,
                    _ item: Any) {
        self.logConsole(item)
        self.logSystem(item)
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

// MARK: WarningOnlyLogger
public class WarningOnlyLogger: ConsoleLogger {
    override public func log(_ type: LogType,
                             _ item: Any) {
        guard type.rawValue >= LogType.warning.rawValue else { return }
        super.log(type, item)
    }
}

// MARK: ErrorOnlyLogger
public class ErrorOnlyLogger: ConsoleLogger {
    override public func log(_ type: LogType,
                             _ item: Any) {
        guard type.rawValue >= LogType.error.rawValue else { return }
        super.log(type, item)
    }
}

// MARK: SystemOnlyLogger
public class SystemOnlyLogger: ConsoleLogger {
    override internal func logConsole(_ item: Any) { }
}
