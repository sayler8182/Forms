//
//  UIStackView.swift
//  Utils
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public extension UIStackView {
    func removeArrangedSubviews() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
        }
    } 
}
