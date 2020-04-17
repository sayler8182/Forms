//
//  UIEdgeInset.swift
//  Utils
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    var leading: CGFloat {
        return UIView.isRightToLeft ? self.right : self.left
    }
    var trailing: CGFloat {
        return UIView.isRightToLeft ? self.left : self.right
    }
    var horizontal: CGFloat {
        return self.left + self.right
    }
    var vertical: CGFloat {
        return self.top + self.bottom
    }
    
    init(top: CGFloat = 0,
         leading: CGFloat = 0,
         bottom: CGFloat = 0,
         trailing: CGFloat = 0) {
        if UIView.isRightToLeft {
            self.init(top: top, left: trailing, bottom: bottom, right: leading)
        } else {
            self.init(top: top, left: leading, bottom: bottom, right: trailing)
        }
    }
    
    init(vertical: CGFloat = 0,
         horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    init(_ value: CGFloat) {
        self.init(vertical: value, horizontal: value)
    }
}
