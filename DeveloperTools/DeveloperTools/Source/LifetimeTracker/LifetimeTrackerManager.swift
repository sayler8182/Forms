//
//  LifetimeTrackerManager.swift
//  DeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit
  
// MARK: EntryGroupModel
struct EntryGroupModel {
    let groups: [GroupModel]
    let leaksCount: Int
}
    
// MARK: EntryModel
struct EntryModel {
    let color: UIColor
    let description: String
}

// MARK: GroupModel
struct GroupModel {
    let color: UIColor
    let title: String
    let groupName: String
    let groupCount: Int
    let groupMaxCount: Int
    let entries: [EntryModel]
}

// MARK: LifetimeTrackerManager
public class LifetimeTrackerManager: NSObject {
    public var visibility: Visibility = .visibleWithIssues
    
    private lazy var lifetimeTrackerView: UIViewController & LifetimeTrackerViewable = {
        return LifetimeTrackerDashboardViewController()
    }()

    public static var scene: UIWindowScene! {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    private lazy var window: UIWindow = {
        let window = UIWindow(windowScene: Self.scene)
        window.windowLevel = UIWindow.Level.statusBar
        window.frame = UIScreen.main.bounds
        window.rootViewController = self.lifetimeTrackerView
        return window
    }()
    
    public convenience init(visibility: Visibility) {
        self.init()
        self.visibility = visibility
    }

    public func refresh(_ trackedGroups: [String: LifetimeEntriesGroup]) {
        DispatchQueue.main.async {
            let hasIssues: Bool = self.hasIssues(in: trackedGroups)
            let entries = self.entries(from: trackedGroups)
            let dashboard = LifetimeTrackerDashboard(
                leaksCount: entries.leaksCount,
                summary: self.summary(from: trackedGroups),
                sections: entries.groups)
            let isEnabled: Bool = !self.visibility.isHidden(hasIssues: hasIssues)
            self.lifetimeTrackerView.update(
                with: dashboard,
                on: self.window,
                isEnabled: isEnabled)
        }
    }
    
    private func summary(from groups: [String: LifetimeEntriesGroup]) -> NSAttributedString {
        let names: [String] = groups.keys.sorted(by: >)
        let summaries: String = names
            .filter { groups[$0]?.lifetimeState == .leaky }
            .compactMap { groups[$0] }
            .map { $0.debugDescription }
            .joined(separator: ", ")
        let color: UIColor = summaries.isEmpty
            ? UIColor.green
            : UIColor.red
        let summary: String = summaries.isEmpty
            ? "Detected: \(summaries)"
            : "No issues detected"
        return NSAttributedString(
            string: summary,
            attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    private func entries(from trackedGroups: [String: LifetimeEntriesGroup]) -> EntryGroupModel {
        var groups: [GroupModel] = []
        var leaksCount: Int = 0
        trackedGroups
            .filter { !$0.value.isEmpty }
            .sorted { ($0.value.maxCount - $0.value.count) < ($1.value.maxCount - $1.value.count) }
            .forEach { (name: String, group: LifetimeEntriesGroup) in
                var entries: [EntryModel] = []
                group.entries
                    .sorted { $0.value.count > $1.value.count }
                    .filter { !$0.value.isEmpty }
                    .forEach { (_, entry: LifetimeEntry) in
                        if entry.lifetimeState == .leaky {
                            leaksCount += entry.count - entry.maxCount
                        }
                        entries.append(EntryModel(
                            color: entry.lifetimeState.color,
                            description: entry.debugDescription))
                }
                groups.append(GroupModel(
                    color: group.lifetimeState.color,
                    title: group.debugDescription,
                    groupName: group.name,
                    groupCount: group.count,
                    groupMaxCount: group.maxCount,
                    entries: entries))
        }
        return EntryGroupModel(
            groups: groups,
            leaksCount: leaksCount)
    }
    
    private func hasIssues(in trackedGroups: [String: LifetimeEntriesGroup]) -> Bool {
        return trackedGroups.keys.contains(where: { trackedGroups[$0]?.lifetimeState == .leaky })
    }
}

// MARK: LifetimeState
extension LifetimeState {
    var color: UIColor {
        switch self {
        case .valid: return UIColor.green
        case .leaky: return UIColor.red
        }
    }
}

// MARK: Visibility
public extension LifetimeTrackerManager {
    enum Visibility {
        case alwaysHidden
        case alwaysVisible
        case visibleWithIssues
        
        func isHidden(hasIssues: Bool) -> Bool {
            switch self {
            case .alwaysHidden: return true
            case .alwaysVisible: return false
            case .visibleWithIssues: return !hasIssues
            }
        }
    }
}

// MARK: LifetimeHideOption
enum LifetimeHideOption {
    case untilMoreIssue
    case untilNewIssueType
    case never
    case none

    func isVisible(old: LifetimeTrackerDashboard?,
                   new: LifetimeTrackerDashboard) -> Bool {
        guard let old: LifetimeTrackerDashboard = old else { return true }
        switch self {
        case .untilMoreIssue:
            return old.leaksCount < new.leaksCount
        case .untilNewIssueType:
            var oldSet = Set<String>()
            for item in old.sections {
                oldSet.insert(item.groupName)
            }
            for item in new.sections {
                if !oldSet.contains(item.groupName) && item.entries.count > item.entries.capacity {
                    return true
                } else if let oldItem = old.sections.first(where: { $0.groupName == item.groupName }),
                    oldItem.groupCount <= oldItem.groupMaxCount && item.groupCount > item.groupMaxCount {
                    return true
                }
            }
            return false
        case .never:
            return false
        default:
            return true
        }
    }
}

// MARK: LifetimeTrackerManager
extension LifetimeTrackerManager {
    static func showLifetimeSettings(on window: UIWindow,
                                     completion: @escaping (LifetimeHideOption) -> Void) {
        guard let controller = window.rootViewController else { return }
        window.isHidden = false
        let _completion: (LifetimeHideOption) -> Void = { (option) in
            window.isHidden = true
            completion(option)
        }
        let alert = UIAlertController(
            title: "Settings",
            message: nil,
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Hide Lifetime", style: .default) { _ in
            let alert = UIAlertController(title: "Hide until ...", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "more issues are detected", style: .default) { _ in
                _completion(.untilMoreIssue)
            })
            alert.addAction(UIAlertAction(title: "new issue types are detected", style: .default) { _ in
                _completion(.untilNewIssueType)
            })
            alert.addAction(UIAlertAction(title: "the app was restarted", style: .default) { _ in
                _completion(.never)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                _completion(.none)
            })
            controller.present(alert, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            _completion(.none)
        })
        controller.present(alert, animated: true, completion: nil)
    }
}

// MARK: Builder
extension LifetimeTrackerManager {
    func with(visibility: Visibility) -> Self {
        self.visibility = visibility
        return self
    }
}
