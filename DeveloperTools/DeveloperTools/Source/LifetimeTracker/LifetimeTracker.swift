//
//  LifetimeTracker.swift
//  DeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: LifetimeConfiguration
public class LifetimeConfiguration: NSObject {
    public var maxCount: Int
    public var groupName: String
    public var groupMaxCount: Int?
    
    fileprivate var instanceName: String = ""
    fileprivate var instancePointer: String = ""
    
    public init(maxCount: Int,
                groupType: Any.Type,
                groupMaxCount: Int? = nil) {
        self.maxCount = maxCount
        self.groupName = "\(groupType)"
        self.groupMaxCount = groupMaxCount
    }
    
    public init(maxCount: Int,
                groupName: String = "lifetimetracker.nogroup.identifier",
                groupMaxCount: Int? = nil) {
        self.maxCount = maxCount
        self.groupName = groupName
        self.groupMaxCount = groupMaxCount
    }
    
    fileprivate func update(instance: LifetimeTrackable) {
        let instanceType: LifetimeTrackable.Type = type(of: instance)
        self.instanceName = "\(instanceType)"
        self.instancePointer = Unmanaged<AnyObject>.passUnretained(instance as AnyObject).toOpaque().debugDescription
    }
    
    fileprivate static func configuration(with instance: LifetimeTrackable) -> LifetimeConfiguration {
        let instanceType: LifetimeTrackable.Type = type(of: instance)
        let configuration: LifetimeConfiguration = instanceType.lifetimeConfiguration
        configuration.update(instance: instance)
        return configuration
    }
}

// MARK: Builder
public extension LifetimeConfiguration {
    func with(maxCount: Int) -> Self {
        self.maxCount = maxCount
        return self
    }
    func with(groupName: String) -> Self {
        self.groupName = groupName
        return self
    }
    func with(groupMaxCount: Int) -> Self {
        self.groupMaxCount = groupMaxCount
        return self
    }
}

// MARK: LifetimeTrackable
@objc public protocol LifetimeTrackable: class {
    static var lifetimeConfiguration: LifetimeConfiguration { get }
}

// MARK: LifetimeTrackable
public extension LifetimeTrackable {
    func lifetimeTrack() {
        LifetimeTracker.shared.track(self, configuration: Self.lifetimeConfiguration)
    }
}

// MARK: LifetimeTracker
public class LifetimeTracker: NSObject {
    public typealias OnUpdate = (_ trackedGroups: [String: LifetimeEntriesGroup]) -> Void
    
    fileprivate static var shared = LifetimeTracker()
    
    fileprivate let lock = NSRecursiveLock()
    fileprivate var trackedGroups: [String: LifetimeEntriesGroup] = [:]
    fileprivate var onUpdate: OnUpdate?
    
    fileprivate static var refresh: ([String: LifetimeEntriesGroup]) -> Void = {
        return LifetimeTrackerManager().refresh
    }()
    
    public static func configure(_ onUpdate: OnUpdate? = nil) {
        Self.shared.onUpdate = onUpdate ?? self.refresh
    }
    
    fileprivate func track(_ instance: LifetimeTrackable,
                           configuration: LifetimeConfiguration,
                           file: String = #file) {
        self.lock.lock()
        configuration.update(instance: instance)
        self.update(configuration, with: +1)
        onDealloc(of: instance) {
            self.lock.lock()
            self.update(configuration, with: -1)
            self.onUpdate?(self.trackedGroups)
            self.lock.unlock()
        }
        self.onUpdate?(self.trackedGroups)
        self.lock.unlock()
    }
    
    fileprivate func update(_ configuration: LifetimeConfiguration,
                            with countDelta: Int) {
        let groupName: String = configuration.groupName
        let group = self.trackedGroups[groupName] ?? LifetimeEntriesGroup(name: groupName)
        group.update(configuration, with: countDelta)
        self.trackedGroups[groupName] = group
    }
    
    override public var debugDescription: String {
        self.lock.lock()
        let keys: [String] = self.trackedGroups.keys.sorted(by: >)
        let description: String = keys.reduce(into: "") { (acc, key) in
            guard let group = self.trackedGroups[key],
                group.lifetimeState == .leaky else { return }
            acc += "\(String(describing: group.name)): \(group.count)\n"
        }
        self.lock.unlock()
        return description
    }
}

// MARK: LifetimeState
public enum LifetimeState {
    case valid
    case leaky
}

// MARK: LifetimeEntry
public class LifetimeEntry {
    let name: String
    var maxCount: Int
    var count: Int
    var pointers: Set<String>
    
    var isEmpty: Bool {
        return self.count < 0 // swiftlint:disable:this empty_count
    }
    
    init(name: String,
         maxCount: Int) {
        self.name = name
        self.maxCount = maxCount
        self.count = 0
        self.pointers = Set<String>()
    }
    
    func update(pointer: String,
                for countDelta: Int) {
        self.count += countDelta
        if countDelta > 0 {
            self.pointers.insert(pointer)
        } else {
            self.pointers.remove(pointer)
        }
    }
    
    var lifetimeState: LifetimeState {
        return self.count > self.maxCount ? .leaky : .valid
    }
    
    var debugDescription: String {
        return "\(self.name) (\(self.count)/\(self.maxCount)):\n\(self.pointers.joined(separator: ", "))"
    }
}

public class LifetimeEntriesGroup: NSObject {
    let name: String
    var maxCount: Int = 0
    var count: Int = 0
    var entries: [String: LifetimeEntry] = [:]
    var usedMaxCountOverride = false
    
    var isEmpty: Bool {
        return self.count <= 0 // swiftlint:disable:this empty_count
    }
    
    init(name: String) {
        self.name = name
    }
    
    var lifetimeState: LifetimeState {
        guard self.count <= self.maxCount else { return .leaky }
        let leakyEntries: [String: LifetimeEntry] = self.entries.filter { $0.value.lifetimeState == .leaky }
        return leakyEntries.isEmpty ? .valid : .leaky
    }
    
    func update(_ configuration: LifetimeConfiguration,
                with countDelta: Int) {
        let entryName: String = configuration.instanceName
        let didEntryExistBefore: Bool = self.entries[entryName] != nil
        let entry = self.entries[entryName] ?? LifetimeEntry(name: entryName, maxCount: configuration.maxCount)
        let entryMaxCountOffset = configuration.maxCount - entry.maxCount
        entry.maxCount += entryMaxCountOffset
        entry.update(pointer: configuration.instancePointer, for: countDelta)
        self.entries[entryName] = entry
        self.count += countDelta
        
        if let groupMaxCount = configuration.groupMaxCount {
            self.usedMaxCountOverride = true
            self.maxCount = groupMaxCount
        } else if !self.usedMaxCountOverride && !didEntryExistBefore {
            self.maxCount += configuration.maxCount
        } else {
            self.maxCount += entryMaxCountOffset
        }
    }
    
    override public var debugDescription: String {
        return "\(self.name) (\(self.count)/\(self.maxCount))"
    }
}

// MARK: LifetimeTrackerDealloc
private class LifetimeTrackerDealloc {
    let onDealloc: () -> Void
    
    init(onDealloc: @escaping () -> Void) {
        self.onDealloc = onDealloc
    }
    
    deinit {
        onDealloc()
    }
}

// MARK: onDealloc
internal func onDealloc(of owner: Any, closure: @escaping () -> Void) {
    var tracker = LifetimeTrackerDealloc(onDealloc: closure)
    objc_setAssociatedObject(owner, &tracker, tracker, .OBJC_ASSOCIATION_RETAIN)
}
