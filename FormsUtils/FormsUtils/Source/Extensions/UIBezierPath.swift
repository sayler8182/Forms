//
//  UIBezierPath.swift
//  FormsUtils
//
//  Created by Konrad on 6/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIBezierPath
public extension UIBezierPath {
    convenience init(size: CGSize,
                     corners: Int = 5,
                     smoothness: CGFloat = 0.45) {
        self.init()
        guard corners >= 2 else { return }
        let center: CGPoint = CGPoint(
            x: size.width / 2,
            y: size.height / 2)
        var currentAngle: CGFloat = -CGFloat.pi / 2
        let angleAdjustment: CGFloat = CGFloat.pi * 2 / CGFloat(corners * 2)
        let innerX: CGFloat = center.x * smoothness
        let innerY: CGFloat = center.y * smoothness
        
        self.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
        var bottomEdge: CGFloat = 0
        for corner in 0..<corners * 2 {
            let sinAngle: CGFloat = sin(currentAngle)
            let cosAngle: CGFloat = cos(currentAngle)
            let bottom: CGFloat
            if corner.isMultiple(of: 2) {
                bottom = center.y * sinAngle
                self.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                bottom = innerY * sinAngle
                self.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }
            bottomEdge = max(bottom, bottomEdge)
            currentAngle += angleAdjustment
        }
        let unusedSpace: CGFloat = (size.height / 2 - bottomEdge) / 2
        let transform: CGAffineTransform = CGAffineTransform(
            translationX: center.x,
            y: center.y + unusedSpace)
        self.apply(transform)
    }
}
