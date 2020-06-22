//
//  View.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: View
open class View: FormsComponent {
    open var height: CGFloat = UITableView.automaticDimension
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
}

// MARK: View
public extension View { 
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
}
