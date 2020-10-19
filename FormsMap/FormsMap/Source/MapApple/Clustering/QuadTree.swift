//
//  QuadTree.swift
//  FormsMapKit
//
//  Created by Konrad on 10/26/20.
//

import MapKit

// MARK: MapAppleAnnotationsContainer
internal protocol MapAppleAnnotationsContainer {
    func add(_ annotation: MKAnnotation) -> Bool
    func remove(_ annotation: MKAnnotation) -> Bool
    func annotations(in rect: MKMapRect) -> [MKAnnotation]
}

// MARK: QuadTreeNode
internal class QuadTreeNode {
    enum NodeType {
        case leaf
        case `internal`(children: Children)
    }
    
    struct Children: Sequence {
        let northWest: QuadTreeNode
        let northEast: QuadTreeNode
        let southWest: QuadTreeNode
        let southEast: QuadTreeNode
        
        init(parentNode: QuadTreeNode) {
            let mapRect: MKMapRect = parentNode.rect
            northWest = QuadTreeNode(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.minY, maxX: mapRect.midX, maxY: mapRect.midY))
            northEast = QuadTreeNode(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.minY, maxX: mapRect.maxX, maxY: mapRect.midY))
            southWest = QuadTreeNode(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.midY, maxX: mapRect.midX, maxY: mapRect.maxY))
            southEast = QuadTreeNode(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.midY, maxX: mapRect.maxX, maxY: mapRect.maxY))
        }
        
        struct ChildrenIterator: IteratorProtocol {
            private var index = 0
            private let children: Children
            
            init(children: Children) {
                self.children = children
            }
            
            mutating func next() -> QuadTreeNode? {
                defer { self.index += 1 }
                switch self.index {
                case 0: return self.children.northWest
                case 1: return self.children.northEast
                case 2: return self.children.southWest
                case 3: return self.children.southEast
                default: return nil
                }
            }
        }
        
        func makeIterator() -> ChildrenIterator {
            return ChildrenIterator(children: self)
        }
    }
    
    var annotations: [MKAnnotation] = []
    let rect: MKMapRect
    var type: NodeType = .leaf
    
    static let maxPointCapacity = 8
    
    init(rect: MKMapRect) {
        self.rect = rect
    }
}

// MARK: QuadTreeNode - MapAppleAnnotationsContainer
extension QuadTreeNode: MapAppleAnnotationsContainer {
    @discardableResult
    func add(_ annotation: MKAnnotation) -> Bool {
        guard self.rect.contains(annotation.coordinate) else { return false }
        
        switch type {
        case .leaf:
            self.annotations.append(annotation)
            if self.annotations.count == QuadTreeNode.maxPointCapacity {
                self.subdivide()
            }
        case .internal(let children):
            for child in children where child.add(annotation) {
                return true
            }
        }
        return true
    }
    
    @discardableResult
    func remove(_ annotation: MKAnnotation) -> Bool {
        guard self.rect.contains(annotation.coordinate) else { return false }
        _ = self.annotations.map { $0.coordinate }
            .firstIndex(of: annotation.coordinate)
            .map { self.annotations.remove(at: $0) }
        
        switch type {
        case .leaf: break
        case .internal(let children):
            for child in children where child.remove(annotation) {
                return true
            }
        }
        return true
    }
    
    private func subdivide() {
        switch type {
        case .leaf:
            self.type = .internal(children: Children(parentNode: self))
        case .internal:
            break
        }
    }
    
    func annotations(in rect: MKMapRect) -> [MKAnnotation] {
        guard self.rect.intersects(rect) else { return [] }
        var result: [MKAnnotation] = []
        for annotation in annotations where rect.contains(annotation.coordinate) {
            result.append(annotation)
        }
        
        switch type {
        case .leaf: break
        case .internal(let children):
            for childNode in children {
                result.append(contentsOf: childNode.annotations(in: rect))
            }
        }
        
        return result
    }
}

// MARK: QuadTree - MapAppleAnnotationsContainer
public class QuadTree: MapAppleAnnotationsContainer {
    let root: QuadTreeNode
    
    public init(rect: MKMapRect) {
        self.root = QuadTreeNode(rect: rect)
    }
    
    @discardableResult
    public func add(_ annotation: MKAnnotation) -> Bool {
        return root.add(annotation)
    }
    
    @discardableResult
    public func remove(_ annotation: MKAnnotation) -> Bool {
        return root.remove(annotation)
    }
    
    public func annotations(in rect: MKMapRect) -> [MKAnnotation] {
        return root.annotations(in: rect)
    }
}
