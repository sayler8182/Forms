//
//  Cache.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsLogger
import Foundation

// MARK: NetworkCache
public protocol NetworkCache {
    init(ttl: TimeInterval)
    
    func isCached(hash: Any) throws -> Bool
    func write(hash: Any,
               data: Data,
               logger: Logger?) throws
    func read(hash: Any,
              logger: Logger?) throws -> Data?
    func reset() throws
    func clean() throws
}

// MARK: NetworkVoidCache
public class NetworkVoidCache: NetworkCache {
    public required init(ttl: TimeInterval) { }
    
    public func isCached(hash: Any) throws -> Bool { return false }
    public func write(hash: Any, data: Data, logger: Logger?) throws { }
    public func read(hash: Any, logger: Logger?) throws -> Data? { return nil }
    public func reset() throws { }
    public func clean() throws { }
}

// MARK: NetworkTmpCache
public class NetworkTmpCache: NetworkCache {
    private let fileManager = FileManager.default
    private let directory: URL = FileManager.default.temporaryDirectory.appendingPathComponent("networking_cache")
    private let ttl: TimeInterval
    
    public required init(ttl: TimeInterval) {
        self.ttl = ttl
        try? self.fileManager.createDirectory(at: self.directory, withIntermediateDirectories: false, attributes: .none)
    }
    
    public func isCached(hash: Any) throws -> Bool {
        try self.clean()
        guard let _: URL = try self.fileManager.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil)
            .first(where: { $0.absoluteString.contains("_\(hash).") }) else { return false }
        return true
    }
    
    public func write(hash: Any,
                      data: Data,
                      logger: Logger? = nil) throws {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970 + self.ttl
        let expirationDate: Int64 = Int64(timeInterval)
        let url: URL = self.directory.appendingPathComponent("_\(hash).\(expirationDate).cache")
        try? self.fileManager.removeItem(at: url)
        try data.write(to: url)
        logger?.log(LogType.info, "Write to cache: \(url.absoluteString)")
    }
    
    public func read(hash: Any,
                     logger: Logger? = nil) throws -> Data? {
        try self.clean()
        guard let url: URL = try self.fileManager.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil)
            .first(where: { $0.absoluteString.contains("_\(hash).") }) else { return nil }
        logger?.log(LogType.info, "Read from cache: \(url.absoluteString)")
        return try Data(contentsOf: url)
    }
    
    public func reset() throws {
        try self.fileManager.removeItem(at: self.directory)
        try self.fileManager.createDirectory(at: self.directory, withIntermediateDirectories: false, attributes: .none)
    }
    
    public func clean() throws {
        let now: TimeInterval = Date().timeIntervalSince1970
        let urls: [URL] = try self.fileManager.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil)
        for url in urls {
            let string: String = url.absoluteString.components(separatedBy: ".")[1]
            let expirationDate: TimeInterval = TimeInterval(string) ?? 0
            if now >= expirationDate {
                try? self.fileManager.removeItem(at: url)
            }
        }
    }
}
