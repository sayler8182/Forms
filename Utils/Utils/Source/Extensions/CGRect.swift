//
//  CGRect.swift
//  Utils
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: CGRect
public extension CGRect {
    init(width: CGFloat,
         height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }
    
    init(size: CGFloat) {
        self.init(width: size, height: size)
    }
}

// MARK: Builder
public extension CGRect {
    func with(inset: UIEdgeInsets) -> CGRect {
        let rect: CGRect = CGRect(
            x: self.origin.x - inset.leading,
            y: self.origin.x - inset.top,
            width: self.size.width - inset.leading - inset.trailing,
            height: self.size.height - inset.top - inset.bottom)
        return rect
    }
}
