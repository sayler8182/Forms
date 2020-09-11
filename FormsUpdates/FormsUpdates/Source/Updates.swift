//
//  Updates.swift
//  FormsUpdates
//
//  Created by Konrad on 9/9/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import Foundation

// MARK: StorageKey
public extension Updates {
    enum StorageKeys: String {
        case postponedVersion = "UpdatesPostponedVersion"
    }
}

// MARK: UpdatesStatus
public enum UpdatesStatus {
    case newVersion(_ old: Version?, _ new: Version)
    case noChanges
    case postponed
    case undefined
    
    public var isAvailable: Bool {
        switch self {
        case .newVersion: return true
        default: return false
        }
    }
}
    
// MARK: UpdatesTask
public class UpdatesTask {
    public var isCancelled: Bool = false
    
    public func cancel() {
        self.isCancelled = true
    }
}

// MARK: UpdatesProtocol
public protocol UpdatesProtocol {
    @discardableResult
    func check(completion: @escaping ((UpdatesStatus) -> Void)) -> UpdatesTask
    func markAsChecked()
    func postpone()
}

// MARK: Updates
public class Updates: UpdatesProtocol {
    private let userDefaults = UserDefaults.standard
    private let queue = DispatchQueue(label: "com.limbo.FormsUpdates", qos: .default)
    private let bundleId: String?
    private let currentVersion: Version?
    private var _appStoreVersion: Version?
    
    private var postponedVersion: Version? {
        get { return Version(self.userDefaults.object(forKey: StorageKeys.postponedVersion.rawValue) as? String) }
        set {
            self.userDefaults.set(newValue?.description, forKey: StorageKeys.postponedVersion.rawValue)
            self.userDefaults.synchronize()
        }
    }
    
    public convenience init(bundle bundleId: String?,
                            version currentVersion: String?) {
        self.init(
            bundle: bundleId,
            version: Version(currentVersion))
    }
    
    public init(bundle bundleId: String?,
                version currentVersion: Version?) {
        self.bundleId = bundleId
        self.currentVersion = currentVersion
    }
    
    @discardableResult
    public func check(completion: @escaping ((UpdatesStatus) -> Void)) -> UpdatesTask {
        let task: UpdatesTask = UpdatesTask()
        let _completion = { (status: UpdatesStatus) in
            guard !task.isCancelled else { return }
            DispatchQueue.main.async { completion(status) }
        }
        self.queue.async {
            guard let appStore: Version = self.appStoreVersion() else {
                _completion(.undefined)
                return
            }
            guard let current: Version = self.currentVersion else {
                _completion(.newVersion(nil, appStore))
                return
            }
            guard appStore > current else {
                _completion(.noChanges)
                return
            }
            if let postponed: Version = self.postponedVersion {
                let status: UpdatesStatus = appStore > postponed
                    ? UpdatesStatus.newVersion(current, appStore)
                    : UpdatesStatus.postponed
                _completion(status)
                return
            }
            _completion(.newVersion(current, appStore))
        }
        return task
    }
    
    public func markAsChecked() {
        self.postponedVersion = nil
    }
    
    public func postpone() {
        self.postponedVersion = self._appStoreVersion
    }
    
    private func appStoreVersion() -> Version? {
        guard let bundleId: String = self.bundleId else { return self._appStoreVersion }
        guard let url: URL = String(format: "http://itunes.apple.com/lookup?bundleId=%@", bundleId).url else { return self._appStoreVersion }
        guard let data: Data = try? Data(contentsOf: url) else { return self._appStoreVersion }
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { return self._appStoreVersion }
        guard let results = json["results"] as? [Any] else { return self._appStoreVersion }
        guard let result = results.first as? [String: Any] else { return self._appStoreVersion }
        guard let version = result["version"] as? String else { return self._appStoreVersion }
        let appStoreVersion: Version? = Version(version)
        self._appStoreVersion = appStoreVersion
        return appStoreVersion
    }
}
