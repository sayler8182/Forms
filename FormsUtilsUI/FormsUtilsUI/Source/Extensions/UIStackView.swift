//
//  UIStackView.swift
//  FormsUtils
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIStackView
public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    func removeArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func removeArrangedSubviews() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    } 
}
