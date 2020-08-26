//
//  Utils.swift
//  FormsTransitions
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

// MARK: UIView
public extension UIView {
    private static var viewKey: UInt8 = 0 
    
    var viewKey: String? {
        get { return getObject(self, &Self.viewKey) }
        set { setObject(self, &Self.viewKey, newValue) }
    }
    
    func with(viewKey: String) -> Self {
        self.viewKey = viewKey
        return self
    }
}

// MARK: UIView
internal extension UIView {
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: currentContext)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
