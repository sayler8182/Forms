//
//  View.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: View
open class View: FormsComponent {
    open var height: CGFloat = UITableView.automaticDimension
    
    override open func setupView() {
        self.setupComponent()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    private func setupComponent() {
        self.anchors([
            Anchor.to(self).fill
        ])
    }
}

// MARK: View
public extension View { 
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
}
