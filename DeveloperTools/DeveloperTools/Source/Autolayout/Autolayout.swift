//
//  Autolayout.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import UIKit

// MARK: Worker
public class Autolayout {
    internal let reader = AutolayoutReader()
    internal let writer = AutolayoutWriter()
    internal let interceptor = AutolayoutInterceptor()
    internal var source: DispatchSourceRead
    
    internal static var shared: Autolayout = Autolayout()
    
    private let lock = NSLock()
    
    internal init() {
        UIView.swizzle()
        self.source = DispatchSource.makeReadSource(
            fileDescriptor: self.reader.readingFileDescriptor,
            queue: .init(label: "com.limbo.DeveloperTools.Autolayout"))
    }
    
    public static func configure() {
        Self.shared.configure()
    }
    
    internal func configure() {
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
extension Autolayout: TextOutputStream {
    public func write(_ string: String) {
        guard let data: Data = string.data(using: .utf8) else { return }
        self.writer.write(content: data)
    }
}

// MARK: Utils
internal func _assert(_ condition: Bool,
                      _ message: String = "",
                      _ file: StaticString = #file,
                      _ line: UInt = #line) {
    if condition { return }
    print("[AUTOLAYOUT WARNING]: Unexpected behavior about \(message) in \(file):\(line)")
}
