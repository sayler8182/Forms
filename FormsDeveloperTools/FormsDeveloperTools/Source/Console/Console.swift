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
            "invalid mode 'kCFRunLoopCommonModes'"
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
    logger?.log(.warning, "[AUTOLAYOUT WARNING]: Unexpected behavior about \(message) in \(file):\(line)")
}
