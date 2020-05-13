//
//  ScrollSteps.swift
//  Forms
//
//  Created by Konrad on 5/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: ScrollSteps
public class ScrollSteps {
    public typealias OnUpdate = (_ step: ScrollStep, _ progress: CGFloat) -> Void
    
    public private (set) var steps: [ScrollStep]
    public var onUpdateVertical: OnUpdate?
    public var onUpdateHorizontal: OnUpdate?
    
    public init(_ steps: [ScrollStep],
                onUpdateVertical: OnUpdate? = nil,
                onUpdateHorizontal: OnUpdate? = nil) {
        self.steps = steps
        self.onUpdateVertical = onUpdateVertical
        self.onUpdateHorizontal = onUpdateHorizontal
    }
    
    public func add(_ step: ScrollStep) {
        self.steps.append(step)
    }
    
    public func update(_ point: CGPoint) {
        self.updateVertical(point.y)
        self.updateHorizontal(point.x)
    }
    
    private func updateVertical(_ y: CGFloat) {
        guard let onUpdateVertical = self.onUpdateVertical else { return }
        for step in self.steps {
            let progress: CGFloat = step.progress(for: y)
            onUpdateVertical(step, progress)
        }
    }
    
    private func updateHorizontal(_ x: CGFloat) {
        guard let onUpdateHorizontal = self.onUpdateHorizontal else { return }
        for step in self.steps {
            let progress: CGFloat = step.progress(for: x)
            onUpdateHorizontal(step, progress)
        }
    }
}

// MARK: ScrollStep
public struct ScrollStep: Equatable {
    public let range: Range<CGFloat>
    
    public init(_ range: Range<Int>) {
        self.range = Range<CGFloat>(
            uncheckedBounds: (
                lower: range.lowerBound.asCGFloat,
                upper: range.upperBound.asCGFloat
        ))
    }
    
    public init(_ range: Range<Double>) {
        self.range = Range<CGFloat>(
            uncheckedBounds: (
                lower: range.lowerBound.asCGFloat,
                upper: range.upperBound.asCGFloat
        ))
    }
    
    public init(_ range: Range<CGFloat>) {
        self.range = range
    }
    
    fileprivate func progress(for value: CGFloat) -> CGFloat {
        if value <= self.range.lowerBound {
            return 0.0
        } else if self.range.upperBound <= value {
            return 1.0
        } else if self.range.upperBound != self.range.lowerBound {
            let rangeSize: CGFloat = self.range.upperBound - self.range.lowerBound
            let position: CGFloat = value - self.range.lowerBound
            return position / rangeSize
        } else {
            return 0.0
        }
    }
}
