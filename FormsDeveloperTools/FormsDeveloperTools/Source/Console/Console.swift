//
//  Console.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import Foundation
import UIKit

// MARK: Worker
public class Console {
    internal let interceptor = ConsoleInterceptor()
    internal var source: DispatchSourceRead!
    internal let reader = ConsoleReader()
    internal let writer = ConsoleWriter()
    internal let lock = NSLock()
    
    internal static var shared: Console = Console()
    
    internal init() {
        UIView.swizzle()
        self.source = DispatchSource.makeReadSource(
            fileDescriptor: self.reader.readingFileDescriptor,
            queue: .init(label: "com.limbo.FormsDeveloperTools.Console"))
    }
    
    public static func configure(ignore: [String] = Console.defaultIgnore) {
        Self.shared.configure(ignore: ignore)
    }
    
    internal func configure(ignore: [String]) {
        self.writer.ignore = ignore
        _ = dup2(STDERR_FILENO, self.writer.writingFileDescriptor)
        _ = dup2(self.reader.writingFileDescriptor, STDERR_FILENO)
        self.source.setEventHandler {
            self.lock.lock()
            defer { self.lock.unlock() }
            let data = self.reader.read()
            if self.interceptor.canIntercept {
                self.interceptor.intercept()
            } else {
                self.writer.write(content: data)
            }
        }
        self.source.resume()
    }
    
    internal func save(_ action: @escaping () -> Void) {
        self.interceptor.save(action)
    }
}

// MARK: TextOutputStream
extension Console: TextOutputStream {
    public func write(_ string: String) {
        guard let data: Data = string.data(using: .utf8) else { return }
        self.writer.write(content: data)
    }
}

// MARK: Default Ignore
public extension Console {
    static var defaultIgnore: [String] {
        return [
            "[Firebase/Messaging]",
            "FacebookAdvertiserIDCollectionEnabled is currently",
            "Attempting to load the view of a view controller",
            "Connection 5: unable to determine",
            "[Firebase/Analytics]",
            "Can't find keyplane that supports type",
            "HTTP load failed, 0/0 bytes",
            "Connection to daemon was invalidated",
            "TIC Read Status",
            "Simulator user has requested new graphics quality",
            "[BoringSSL]",
            "[] tcp_input",
            "[tcp] tcp_input",
            "[] tcp_output",
            "[tcp] tcp_output",
            "dlopen libquic failed",
            "Domain=AKAuthenticationError Code=-7003",
            "[] nw_read_request_report",
            "[TableView] Warning once only",
            "TUISystemInputAssistantView.bottom == _UIKBCompatInputView.top",
            "[Common] _BSMachError: port",
            "[logger]",
            "Write to cache",
            "Read from cache",
            "_UIAlertControllerView",
            "he behavior of the UICollectionViewFlowLayout",
            "the item height must be less than the height of the UICollectionView",
            "[Assert] trying to load collection",
            "The relevant UICollectionViewFlowLayout instance is",
            "Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes",
            "[Touch] unexpected nil window in __sendSystemGestureLatentClientUpdate",
            "[Snapshotting] Snapshotting a view",
            "invalid mode 'kCFRunLoopCommonModes'",
            "[MC] System group container for systemgroup.com.apple.configurationprofiles path is",
            "[MC] Reading from private effective user settings.",
            "[Assert] Unexpected code path for search bar hosted by navigation bar. This is a UIKit problem",
            ": encountered error(1:53)",
            "Graph API v2.4",
            "Metal API Validation Enabled",
            "-canOpenURL: failed for URL: \"-",
            "Failed to inherit CoreMedia permissions from",
            "[VKDefault] Style Z is",
            "fopen failed for data file: errno",
            "Errors found! Invalidating cache...",
            " WF: ",
            "API error: <_UIKBCompatInputView:",
            "remote notifications are not supported in the simulator",
            "[Firebase/Crashlytics] Version",
            "Connection 30: unable to determine interface type without",
            "[ShareSheet] connection invalidated"
        ]
    }
}

// MARK: Utils
internal func consoleAssert(_ condition: Bool,
                            _ message: String = "",
                            _ file: StaticString = #file,
                            _ line: UInt = #line) {
    if condition { return }
    let logger: Logger? = Injector.main.resolveOrDefault("FormsDeveloperTools")
    logger?.log(LogType.error, "Unexpected behavior about \(message) in \(file):\(line)")
}
