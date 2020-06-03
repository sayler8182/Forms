//
//  Anchor.swift
//  FormsAnchor
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public enum Position {
    case top
    case bottom
    case topToBottom
    case bottomToTop
    
    case leading
    case trailing
    case leadingToTrailing
    case trailingToLeading
    
    case centerX
    case centerY
    
    case centerXToLeading
    case centerXToTrailing
    case leadingToCenterX
    case trailingToCenterX
    
    case centerYToTop
    case centerYToBottom
    case topToCenterY
    case bottomToCenterY
    
    case width
    case height
    
    case size(Size)
    
    fileprivate var attributes: (first: Attribute, second: Attribute) {
        switch self {
        case .top: return (.top, .top)
        case .bottom: return (.bottom, .bottom)
        case .topToBottom: return (.top, .bottom)
        case .bottomToTop: return (.bottom, .top)
        case .leading: return (.leading, .leading)
        case .trailing: return (.trailing, .trailing)
        case .leadingToTrailing: return (.leading, .trailing)
        case .trailingToLeading: return (.trailing, .leading)
        case .centerX: return (.centerX, .centerX)
        case .centerY: return (.centerY, .centerY)
        case .centerXToLeading: return (.centerX, .leading)
        case .centerXToTrailing: return (.centerX, .trailing)
        case .leadingToCenterX: return (.leading, .centerX)
        case .trailingToCenterX: return (.trailing, .centerX)
        case .centerYToTop: return (.centerY, .top)
        case .centerYToBottom: return (.centerY, .bottom)
        case .topToCenterY: return (.top, .centerY)
        case .bottomToCenterY: return (.bottom, .centerY)
        case .width: return (.width, .width)
        case .height: return (.height, .height)
        case .size(let size):
            switch size {
            case .width: return (.width, .notAnAttribute)
            case .height: return (.height, .notAnAttribute)
            }
        }
    }
}

public enum Size {
    case width(CGFloat)
    case height(CGFloat)
}

public enum LayoutGuide {
    case normal
    case safeArea
    case margins
}

public typealias Constraint = NSLayoutConstraint
public typealias Relation = NSLayoutConstraint.Relation
public typealias YAxisAnchor = NSLayoutYAxisAnchor
public typealias XAxisAnchor = NSLayoutXAxisAnchor
public typealias Dimension = NSLayoutDimension
public typealias Priority = UILayoutPriority
public typealias Attribute = NSLayoutConstraint.Attribute

public protocol AnchorLayoutGuide {
    var topAnchor: YAxisAnchor { get }
    var bottomAnchor: YAxisAnchor { get }
    var leadingAnchor: XAxisAnchor { get }
    var trailingAnchor: XAxisAnchor { get }
    var centerXAnchor: XAxisAnchor { get }
    var centerYAnchor: YAxisAnchor { get }
    var widthAnchor: Dimension { get }
    var heightAnchor: Dimension { get }
}
extension UIView: AnchorLayoutGuide { }
extension UILayoutGuide: AnchorLayoutGuide { }

public extension UILayoutPriority {
    static var veryLow: UILayoutPriority = UILayoutPriority(100)
}

public class AnchorConnection {
    public var constraint: Constraint?
    
    public var constant: CGFloat? {
        get { return self.constraint?.constant }
        set {
            guard let newValue = newValue else { return }
            self.constraint?.constant = newValue
        }
    }
    
    public init() { }
}

public struct Anchor {
    let view: UIView
    private (set) var positions: [Position]
    private (set) var offset: CGFloat
    private (set) var multiplier: CGFloat
    private (set) var relation: Relation
    private (set) var layoutGuide: LayoutGuide
    private (set) var priority: Priority
    private (set) var connection: AnchorConnection?
    private (set) var isActive: Bool
    
    private init(view: UIView,
                 positions: [Position] = [],
                 offset: CGFloat = 0,
                 multiplier: CGFloat = 1,
                 relation: Relation = .equal,
                 layoutGuide: LayoutGuide = .normal,
                 priority: Priority = .required,
                 connection: AnchorConnection? = nil,
                 isActive: Bool = true) {
        self.view = view
        self.positions = positions
        self.offset = offset
        self.multiplier = multiplier
        self.relation = relation
        self.layoutGuide = layoutGuide
        self.priority = priority
        self.connection = connection
        self.isActive = isActive
    }
    
    public static func to(_ view: UIView) -> Anchor {
        return Anchor(view: view)
    } 
}

// MARK: Config
public extension Anchor {
    func offset(_ offset: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.offset = offset
        return anchor
    }
    
    func multiplier(_ multiplier: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.multiplier = multiplier
        return anchor
    }
    
    func relation(_ relation: Relation) -> Anchor {
        var anchor: Anchor = self
        anchor.relation = relation
        return anchor
    }
    
    func layoutGuide(_ layoutGuide: LayoutGuide) -> Anchor {
        var anchor: Anchor = self
        anchor.layoutGuide = layoutGuide
        return anchor
    }
    
    func priority(_ priority: Priority) -> Anchor {
        var anchor: Anchor = self
        anchor.priority = priority
        return anchor
    }
    
    func connect(_ connection: AnchorConnection) -> Anchor {
        if self.positions.count > 1 { fatalError("Can't connect multiple positions") }
        var anchor: Anchor = self
        anchor.connection = connection
        return anchor
    }
    
    func isActive(_ isActive: Bool) -> Anchor {
        var anchor: Anchor = self
        anchor.isActive = isActive
        return anchor
    }
}

// MARK: Positions
public extension Anchor {
    var top: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.top)
        return anchor
    }
    
    var bottom: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.bottom)
        return anchor
    }
    
    var topToBottom: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.topToBottom)
        return anchor
    }
    
    var bottomToTop: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.bottomToTop)
        return anchor
    }
    
    var leading: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.leading)
        return anchor
    }
    
    var trailing: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.trailing)
        return anchor
    }
    
    var leadingToTrailing: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.leadingToTrailing)
        return anchor
    }
    
    var trailingToLeading: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.trailingToLeading)
        return anchor
    }
    
    var centerX: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerX)
        return anchor
    }
    
    var centerXToLeading: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerXToLeading)
        return anchor
    }
    
    var centerXToTrailing: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerXToTrailing)
        return anchor
    }
    
    var leadingToCenterX: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.leadingToCenterX)
        return anchor
    }
    
    var trailingToCenterX: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.trailingToCenterX)
        return anchor
    }
    
    var centerY: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerY)
        return anchor
    }
    
    var centerYToTop: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerYToTop)
        return anchor
    }
    
    var centerYToBottom: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerYToBottom)
        return anchor
    }
    
    var topToCenterY: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.topToCenterY)
        return anchor
    }
    
    var bottomToCenterY: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.bottomToCenterY)
        return anchor
    }
    
    var width: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.width)
        return anchor
    }
    
    var height: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.height)
        return anchor
    }
    
    func width(_ width: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.size(.width(width)))
        return anchor
    }
    
    func height(_ height: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.size(.height(height)))
        return anchor
    }
    
    func size(_ size: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.size(.width(size)))
        anchor.positions.append(.size(.height(size)))
        return anchor
    }
    
    func size(_ size: CGSize) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.size(.width(size.width)))
        anchor.positions.append(.size(.height(size.height)))
        return anchor
    }
}

// MARK: Positions - Combined
public extension Anchor {
    var vertical: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.top)
        anchor.positions.append(.bottom)
        return anchor
    }
    
    var horizontal: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.leading)
        anchor.positions.append(.trailing)
        return anchor
    }
    
    var fill: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.top)
        anchor.positions.append(.bottom)
        anchor.positions.append(.leading)
        anchor.positions.append(.trailing)
        return anchor
    }
    
    var center: Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerX)
        anchor.positions.append(.centerY)
        return anchor
    }
    
    func centerX(_ width: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerX)
        anchor.positions.append(.size(.width(width)))
        return anchor
    }
    
    func centerY(_ height: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerY)
        anchor.positions.append(.size(.height(height)))
        return anchor
    }
    
    func center(_ width: CGFloat, _ height: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerX)
        anchor.positions.append(.size(.width(width)))
        anchor.positions.append(.centerY)
        anchor.positions.append(.size(.height(height)))
        return anchor
    }
    
    func center(_ size: CGFloat) -> Anchor {
        var anchor: Anchor = self
        anchor.positions.append(.centerX)
        anchor.positions.append(.size(.width(size)))
        anchor.positions.append(.centerY)
        anchor.positions.append(.size(.height(size)))
        return anchor
    }
}

// MARK: Positions - Relation
public extension Anchor {
    var equal: Anchor {
        var anchor: Anchor = self
        anchor.relation = .equal
        return anchor
    }
    
    var greaterThanOrEqual: Anchor {
        var anchor: Anchor = self
        anchor.relation = .greaterThanOrEqual
        return anchor
    }
    
    var lessThanOrEqual: Anchor {
        var anchor: Anchor = self
        anchor.relation = .lessThanOrEqual
        return anchor
    }
}

// MARK: Layout guide
public extension Anchor {
    var normal: Anchor {
        var anchor: Anchor = self
        anchor.layoutGuide = .normal
        return anchor
    }
    
    var safeArea: Anchor {
        var anchor: Anchor = self
        anchor.layoutGuide = .safeArea
        return anchor
    }
    
    var margins: Anchor {
        var anchor: Anchor = self
        anchor.layoutGuide = .margins
        return anchor
    }
}

// MARK: Priority
public extension Anchor {
    var requiredPriority: Anchor {
        var anchor: Anchor = self
        anchor.priority = .required
        return anchor
    }
    
    var highPriority: Anchor {
        var anchor: Anchor = self
        anchor.priority = .defaultHigh
        return anchor
    }
    
    var lowPriority: Anchor {
        var anchor: Anchor = self
        anchor.priority = .defaultLow
        return anchor
    }
    
    func priority(_ value: Int) -> Anchor {
        var anchor: Anchor = self
        let priorityValue = Float(value / 1_000)
        anchor.priority = Priority(priorityValue)
        return anchor
    }
}

// MARK: UIStackView Anchors
public extension UIStackView {
    func insertArrangedSubview(_ view: UIView,
                               at index: Int,
                               with anchors: [Anchor]) {
        self.insertArrangedSubview(view, at: index)
        view.anchors(anchors)
    }
}

// MARK: UIView Anchors
public extension UIView { 
    func addSubview(_ view: UIView,
                    with anchors: [Anchor],
                    layoutIfNeeded: Bool = false) {
        self.addSubview(view)
        view.anchors(anchors)
        if layoutIfNeeded {
            self.layoutIfNeeded()
        }
    }
    
    func with(anchors: (UIView) -> [Anchor]) -> Self {
        self.anchors(anchors(self))
        return self
    }
    
    func anchors(_ anchors: [Anchor]) {
        for anchor in anchors {
            self.set(anchor: anchor)
        }
    }
    
    func set(anchor: Anchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [Constraint] = []
        for position in anchor.positions {
            let anchorLayoutGuide: AnchorLayoutGuide = self.anchorLayoutGuide(from: anchor)
            let constraint: Constraint = self.constraint(
                position: position,
                offset: anchor.offset,
                multiplier: anchor.multiplier,
                relation: anchor.relation,
                anchorLayoutGuide: anchorLayoutGuide)
            constraint.priority = anchor.priority
            anchor.connection?.constraint = constraint
            constraint.isActive = anchor.isActive
            constraints.append(constraint)
        }
    }
    
    func linkedConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        var _view: UIView? = self
        while let view: UIView = _view {
            let _constraints: [NSLayoutConstraint] = view.constraints.filter {
                $0.firstItem === self || $0.secondItem === self
            }
            constraints.append(contentsOf: _constraints)
            _view = view.superview
        }
        return constraints
    }
    
    func constraint(from anchor: Anchor) -> Constraint? {
        guard let position: Position = anchor.positions.last else { return nil }
        let anchorLayoutGuide: AnchorLayoutGuide = self.anchorLayoutGuide(from: anchor)
        let constraint: Constraint = self.constraint(
            position: position,
            offset: anchor.offset,
            multiplier: anchor.multiplier,
            relation: anchor.relation,
            anchorLayoutGuide: anchorLayoutGuide)
        constraint.priority = anchor.priority
        anchor.connection?.constraint = constraint
        constraint.isActive = anchor.isActive
        return constraint
    }
    
    func constraint(from: UIView? = nil,
                    to: UIView? = nil,
                    position: Position,
                    offset: CGFloat? = nil,
                    multiplier: CGFloat? = nil,
                    relation: Relation? = nil,
                    layoutGuide: LayoutGuide? = nil,
                    priority: Priority? = nil) -> NSLayoutConstraint? {
        let from: UIView = from ?? self
        let to: UIView? = to
        let constrains: [NSLayoutConstraint] = self.linkedConstraints()
        let constraint: NSLayoutConstraint? = constrains.first(where: {
            let attributes = position.attributes
            return ![
                $0.firstItem === from,
                offset == nil ? true : $0.secondItem === to,
                offset == nil ? true : $0.constant == offset,
                multiplier == nil ? true : $0.multiplier == multiplier,
                relation == nil ? true : $0.relation == relation,
                priority == nil ? true : $0.priority == priority,
                $0.firstAttribute == .notAnAttribute ? true : $0.firstAttribute == attributes.first,
                $0.secondAttribute == .notAnAttribute ? true : $0.secondAttribute == attributes.second
                ].contains(false)
        })
        return constraint
    }
    
    private func anchorLayoutGuide(from anchor: Anchor) -> AnchorLayoutGuide {
        switch anchor.layoutGuide {
        case .normal:
            return anchor.view
        case .safeArea:
            if #available(iOS 11.0, *) {
                return anchor.view.safeAreaLayoutGuide
            } else {
                return anchor.view
            }
        case .margins:
            return anchor.view.layoutMarginsGuide
        }
    }
}

// MARK: UIView Utils
extension UIView {
    private func constraint(position: Position,
                            offset: CGFloat,
                            multiplier: CGFloat,
                            relation: Relation,
                            anchorLayoutGuide: AnchorLayoutGuide) -> Constraint {
        let view: UIView = self
        switch position {
        case .top:
            return self.constraint(
                from: view.topAnchor,
                to: anchorLayoutGuide.topAnchor,
                relation: relation,
                constant: offset)
        case .bottom:
            return self.constraint(
                from: view.bottomAnchor,
                to: anchorLayoutGuide.bottomAnchor,
                relation: relation.inverted,
                constant: -offset)
        case .topToBottom:
            return self.constraint(
                from: view.topAnchor,
                to: anchorLayoutGuide.bottomAnchor,
                relation: relation,
                constant: offset)
        case .bottomToTop:
            return self.constraint(
                from: view.bottomAnchor,
                to: anchorLayoutGuide.topAnchor,
                relation: relation,
                constant: -offset)
            
        case .leading:
            return self.constraint(
                from: view.leadingAnchor,
                to: anchorLayoutGuide.leadingAnchor,
                relation: relation,
                constant: offset)
        case .trailing:
            return self.constraint(
                from: view.trailingAnchor,
                to: anchorLayoutGuide.trailingAnchor,
                relation: relation.inverted,
                constant: -offset)
        case .leadingToTrailing:
            return self.constraint(
                from: view.leadingAnchor,
                to: anchorLayoutGuide.trailingAnchor,
                relation: relation,
                constant: offset)
        case .trailingToLeading:
            return self.constraint(
                from: view.trailingAnchor,
                to: anchorLayoutGuide.leadingAnchor,
                relation: relation,
                constant: offset)
            
        case .centerX:
            return self.constraint(
                from: view.centerXAnchor,
                to: anchorLayoutGuide.centerXAnchor,
                relation: relation,
                constant: offset)
        case .centerY:
            return self.constraint(
                from: view.centerYAnchor,
                to: anchorLayoutGuide.centerYAnchor,
                relation: relation,
                constant: offset)
            
        case .centerXToLeading:
            return self.constraint(
                from: view.centerXAnchor,
                to: anchorLayoutGuide.leadingAnchor,
                relation: relation,
                constant: offset)
        case .centerXToTrailing:
            return self.constraint(
                from: view.centerXAnchor,
                to: anchorLayoutGuide.trailingAnchor,
                relation: relation,
                constant: offset)
        case .leadingToCenterX:
            return self.constraint(
                from: view.leadingAnchor,
                to: anchorLayoutGuide.centerXAnchor,
                relation: relation,
                constant: offset)
        case .trailingToCenterX:
            return self.constraint(
                from: view.trailingAnchor,
                to: anchorLayoutGuide.centerXAnchor,
                relation: relation,
                constant: -offset)
            
        case .centerYToTop:
            return self.constraint(
                from: view.centerYAnchor,
                to: anchorLayoutGuide.topAnchor,
                relation: relation,
                constant: offset)
        case .centerYToBottom:
            return self.constraint(
                from: view.centerYAnchor,
                to: anchorLayoutGuide.bottomAnchor,
                relation: relation,
                constant: offset)
        case .topToCenterY:
            return self.constraint(
                from: view.topAnchor,
                to: anchorLayoutGuide.centerYAnchor,
                relation: relation,
                constant: offset)
        case .bottomToCenterY:
            return self.constraint(
                from: view.bottomAnchor,
                to: anchorLayoutGuide.centerYAnchor,
                relation: relation,
                constant: -offset)
            
        case .width:
            return self.constraint(
                from: view.widthAnchor,
                to: anchorLayoutGuide.widthAnchor,
                relation: relation,
                multiplier: multiplier,
                constant: offset)
        case .height:
            return self.constraint(
                from: view.heightAnchor,
                to: anchorLayoutGuide.heightAnchor,
                relation: relation,
                multiplier: multiplier,
                constant: offset)
            
        case .size(let size):
            switch size {
            case .width(let width):
                return self.constraint(
                    from: view.widthAnchor,
                    relation: relation,
                    constant: width)
            case .height(let height):
                return self.constraint(
                    from: view.heightAnchor,
                    relation: relation,
                    constant: height)
            }
        }
    }
    
    private func constraint(from source: NSLayoutAnchor<YAxisAnchor>,
                            to destination: NSLayoutAnchor<YAxisAnchor>,
                            relation: Relation,
                            constant: CGFloat) -> Constraint {
        return self.constraint(
            from: source,
            to: destination,
            of: YAxisAnchor.self,
            relation: relation,
            constant: constant)
    }
    
    private func constraint(from source: NSLayoutAnchor<XAxisAnchor>,
                            to destination: NSLayoutAnchor<XAxisAnchor>,
                            relation: Relation,
                            constant: CGFloat) -> Constraint {
        return self.constraint(
            from: source,
            to: destination,
            of: XAxisAnchor.self,
            relation: relation,
            constant: constant)
    }
    
    private func constraint<T: NSObject>(from source: NSLayoutAnchor<T>,
                                         to destination: NSLayoutAnchor<T>,
                                         of type: T.Type,
                                         relation: Relation,
                                         constant: CGFloat) -> Constraint {
        switch relation {
        case .equal:
            return source.constraint(equalTo: destination, constant: constant)
        case .greaterThanOrEqual:
            return source.constraint(greaterThanOrEqualTo: destination, constant: constant)
        case .lessThanOrEqual:
            return source.constraint(lessThanOrEqualTo: destination, constant: constant)
        @unknown default:
            return source.constraint(equalTo: destination, constant: constant)
        }
    }
    
    private func constraint(from source: Dimension,
                            to destination: Dimension,
                            relation: Relation,
                            multiplier: CGFloat,
                            constant: CGFloat) -> Constraint {
        switch relation {
        case .equal:
            return source.constraint(equalTo: destination, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqual:
            return source.constraint(greaterThanOrEqualTo: destination, multiplier: multiplier, constant: constant)
        case .lessThanOrEqual:
            return source.constraint(lessThanOrEqualTo: destination, multiplier: multiplier, constant: constant)
        @unknown default:
            return source.constraint(equalTo: destination, multiplier: multiplier, constant: constant)
        }
    }
    
    private func constraint(from source: Dimension,
                            relation: Relation,
                            constant: CGFloat) -> Constraint {
        switch relation {
        case .equal:
            return source.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            return source.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            return source.constraint(lessThanOrEqualToConstant: constant)
        @unknown default:
            return source.constraint(equalToConstant: constant)
        }
    }
}

// MARK: Relation
private extension Relation {
    var inverted: Relation {
        if self == .greaterThanOrEqual {
            return .lessThanOrEqual
        } else if self == .lessThanOrEqual {
            return .greaterThanOrEqual
        } else {
            return .equal
        }
    }
}
