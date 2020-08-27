//
//  FormsComponent.swift
//  Table
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

public typealias LazyView = (() -> UIView?)
public typealias LazyImage = (() -> UIImage?)

// MARK: SeparatorView
open class SeparatorView: UIView { }

// MARK: Separatorable
public protocol Separatorable {
    var separatorInset: CGFloat { get }
}

public extension Separatorable {
    var separatorInset: CGFloat {
        return 8
    }
}

// MARK: Clickable
public protocol Clickable {
    var onClick: (() -> Void)? { get set }
}

// MARK: Focusable
public protocol Focusable {
    func focus()
    func focus(animated: Bool)
    func lostFocus()
    func lostFocus(animated: Bool)
}
public extension Focusable {
    func focus() {
        self.focus(animated: true)
    }
    
    func lostFocus() {
        self.lostFocus(animated: true)
    }
} 

// MARK: Inputable
public protocol Inputable: Focusable { }

// MARK: Componentable
public protocol Componentable: Themeable {
    func setupView()
    func setupActions()
    func setTheme()
    func setLanguage()
}

// MARK: FormsComponent
open class FormsComponent: UIView, Componentable, BatchUpdateable {
    public weak var table: TableProtocol?
    
    open var isBatchUpdateInProgress: Bool = false
    open var isStartAutoShimmer: Bool = true
    open var isStopAutoShimmer: Bool = true
    open var maxHeight: CGFloat = CGFloat.greatestConstraintConstant {
        didSet { self.updateMaxHeight() }
    }
    open var minHeight: CGFloat = 0.0 {
        didSet { self.updateMinHeight() }
    }
    public var realHeight: CGFloat {
        return self.realSize.height
    }
    public var realWidth: CGFloat {
        return self.realSize.width
    }
    public var realSize: CGSize {
        return self.frame.size
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    public required init() {
        super.init(frame: CGRect(width: 320, height: 44))
        self.setupView()
    }
    
    public var onSetTheme: (() -> Void) = { } {
        didSet { self.onSetTheme() }
    }
    public var onSetLanguage: (() -> Void) = { } {
        didSet { self.onSetLanguage() }
    }
    
    open func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupActions()
        self.setTheme()
        self.setLanguage()
        self.setupAppearance()
        self.setupMock()
    }
    
    open func enable(animated: Bool) {
        self.isUserInteractionEnabled = true
        let subviews: [UIView] = self.subviews.exclude { $0 is SeparatorView }
        for view in subviews {
            view.alpha = 1
        }
    }
    
    open func disable(animated: Bool) {
        self.isUserInteractionEnabled = false
        let subviews: [UIView] = self.subviews.exclude { $0 is Separatorable }
        for view in subviews {
            view.alpha = 0.3
        }
    }
    
    open func setSeparator(_ style: SeparatorStyle) {
        let subviews: [UIView] = self.subviews.filter { $0 is SeparatorView }
        subviews.removeFromSuperview()
        
        guard let separatorable = self as? Separatorable else {
            return
        }
        
        if style.contains(.top) {
            let topSeparator: SeparatorView = SeparatorView()
            self.addSubview(topSeparator, with: [
                Anchor.to(self).top,
                Anchor.to(self).horizontal.offset(separatorable.separatorInset)
            ])
        }
        
        if style.contains(.bottom) {
            let bottomSeparator: SeparatorView = SeparatorView()
            self.addSubview(bottomSeparator, with: [
                Anchor.to(self).top,
                Anchor.to(self).horizontal.offset(separatorable.separatorInset)
            ])
        }
    }
    
    // MARK: HOOKS
    open func setupActions() {
        // HOOK
    }
    
    open func setTheme() {
        self.onSetTheme()
        // HOOK
    }
    
    open func setLanguage() {
        self.onSetLanguage()
        // HOOK
    }
    
    open func componentHeight() -> CGFloat {
        // HOOK
        return UITableView.automaticDimension
    }
    
    open class func componentHeight(_ source: Any,
                                    _ superview: UIView) -> CGFloat {
        // HOOK
        return UITableView.automaticDimension
    }
    
    open func updateMaxHeight() {
        let maxHeight: CGFloat = self.maxHeight
        self.constraint(position: .height, relation: .lessThanOrEqual)?.constant = maxHeight
    }
    
    open func updateMinHeight() {
         let minHeight: CGFloat = self.minHeight
               self.constraint(position: .height, relation: .greaterThanOrEqual)?.constant = minHeight
    }
    
    open func setupAppearance() {
        // HOOK
    }
    
    open func updateState() {
        // HOOK
    }
    
    @objc
    open dynamic func setupMock() {
        // HOOK
    }
}

// MARK: Separator
public struct SeparatorStyle: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = SeparatorStyle(rawValue: 1 << 1)
    public static let bottom = SeparatorStyle(rawValue: 1 << 2)
}

// MARK: XibComponent
open class XibComponent: FormsComponent {
    override open func setupView() {
        let view: UIView = Bundle.main.instantiate(with: self)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        super.setupView()
    }
}

// MARK: Builder
public extension FormsComponent {
    func with(componentColor: UIColor?) -> Self {
        self.backgroundColor = componentColor
        return self
    }
    func with(isAutoShimmer: Bool) -> Self {
        self.isStartAutoShimmer = isAutoShimmer
        self.isStopAutoShimmer = isAutoShimmer
        return self
    }
    func with(isStartAutoShimmer: Bool) -> Self {
        self.isStartAutoShimmer = isStartAutoShimmer
        return self
    }
    func with(isStopAutoShimmer: Bool) -> Self {
        self.isStopAutoShimmer = isStopAutoShimmer
        return self
    }
    func with(maxHeight: CGFloat) -> Self {
        self.maxHeight = maxHeight
        return self
    }
    func with(minHeight: CGFloat) -> Self {
        self.minHeight = minHeight
        return self
    }
} 

// MARK: BatchUpdateable
public protocol BatchUpdateable: class {
    var isBatchUpdateInProgress: Bool { get set }
    
    func updateState()
}
public extension BatchUpdateable {
    func batchUpdate(_ action: () -> Void) {
        guard !self.isBatchUpdateInProgress else { return }
        self.isBatchUpdateInProgress = true
        action()
        self.isBatchUpdateInProgress = false
        self.updateState()
    }
    
    func batchUpdate(_ action: () -> Void, _ finish: () -> Void) {
        guard !self.isBatchUpdateInProgress else { return }
        self.isBatchUpdateInProgress = true
        action()
        self.isBatchUpdateInProgress = false
        finish()
    }
}

// MARK: FormsComponentWithLoading
public protocol FormsComponentWithLoading: class {
    var isLoading: Bool { get set }
}
public extension FormsComponentWithLoading {
    func startLoading(animated: Bool) {
        guard !self.isLoading else { return }
        self.isLoading = true
    }
    func stopLoading(animated: Bool) {
        guard self.isLoading else { return }
        self.isLoading = false
    }
    func with(isLoading: Bool) -> Self {
        self.isLoading = isLoading
        return self
    }
}

// MARK: FormsComponentWithGroup
public protocol FormsComponentWithGroup: class {
    var groupKey: String? { get set }
}
public extension FormsComponentWithGroup {
    func with(groupKey: String?) -> Self {
        self.groupKey = groupKey
        return self
    }
}

// MARK: FormsComponentWithMarginEdgeInset
public protocol FormsComponentWithMarginEdgeInset: class {
    var marginEdgeInset: UIEdgeInsets { get set }
}
public extension FormsComponentWithMarginEdgeInset {
    func with(sumMarginEdgeInset: UIEdgeInsets) -> Self {
        self.marginEdgeInset += sumMarginEdgeInset
        return self
    }
    func with(margin: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(margin)
        return self
    }
    func with(marginEdgeInset: UIEdgeInsets) -> Self {
        self.marginEdgeInset = marginEdgeInset
        return self
    }
    func with(marginHorizontal: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(horizontal: marginHorizontal)
        return self
    }
    func with(marginVertical: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(vertical: marginVertical)
        return self
    }
    func with(marginVertical: CGFloat, marginHorizontal: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(vertical: marginVertical, horizontal: marginHorizontal)
        return self
    }
    func with(marginTop: CGFloat) -> Self {
        self.marginEdgeInset.top = marginTop
        return self
    }
    func with(marginBottom: CGFloat) -> Self {
        self.marginEdgeInset.bottom = marginBottom
        return self
    }
    func with(marginLeading: CGFloat) -> Self {
        self.marginEdgeInset.leading = marginLeading
        return self
    }
    func with(marginTrailing: CGFloat) -> Self {
        self.marginEdgeInset.trailing = marginTrailing
        return self
    }
}

// MARK: FormsComponentWithPaddingEdgeInset
public protocol FormsComponentWithPaddingEdgeInset: class {
    var paddingEdgeInset: UIEdgeInsets { get set }
}
public extension FormsComponentWithPaddingEdgeInset {
    func with(sumPaddingEdgeInset: UIEdgeInsets) -> Self {
        self.paddingEdgeInset += sumPaddingEdgeInset
        return self
    }
    func with(padding: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(padding)
        return self
    }
    func with(paddingEdgeInset: UIEdgeInsets) -> Self {
        self.paddingEdgeInset = paddingEdgeInset
        return self
    }
    func with(paddingHorizontal: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(horizontal: paddingHorizontal)
        return self
    }
    func with(paddingVertical: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(vertical: paddingVertical)
        return self
    }
    func with(paddingVertical: CGFloat, paddingHorizontal: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(vertical: paddingVertical, horizontal: paddingHorizontal)
        return self
    }
    func with(paddingTop: CGFloat) -> Self {
        self.paddingEdgeInset.top = paddingTop
        return self
    }
    func with(paddingBottom: CGFloat) -> Self {
        self.paddingEdgeInset.bottom = paddingBottom
        return self
    }
    func with(paddingLeading: CGFloat) -> Self {
        self.paddingEdgeInset.leading = paddingLeading
        return self
    }
    func with(paddingTrailing: CGFloat) -> Self {
        self.paddingEdgeInset.trailing = paddingTrailing
        return self
    }
}

// MARK: FormsComponentWithProgress
public protocol FormsComponentWithProgress: class {
    var progress: CGFloat { get set }
    
    func setProgress(_ progress: CGFloat,
                     animated: Bool)
}
public extension FormsComponentWithProgress {
    func with(progress: CGFloat) -> Self {
        self.progress = progress
        return self
    }
}

// MARK: DataSource
public extension FormsComponent {
    func cast<D, V: FormsComponent>(section: TableSection,
                                    of dataType: D.Type,
                                    to viewType: V.Type,
                                    success: (D, V) -> Void) {
        self.cast(
            section: section,
            of: dataType,
            to: viewType,
            success: success,
            fail: { })
    }
    
    func cast<D, V: FormsComponent>(section: TableSection,
                                    of dataType: D.Type,
                                    to viewType: V.Type,
                                    success: (D, V) -> Void,
                                    fail: () -> Void) {
        guard let data: D = section.data as? D,
            let view: V = self as? V else {
                return fail()
        }
        success(data, view)
    }
}
