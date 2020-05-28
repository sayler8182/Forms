//
//  UIImageView.swift
//  FormsUtils
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Builder
public extension UIImageView {
    func with(image color: UIColor) -> Self {
        self.image = UIImage(color: color)
        return self
    }
    func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }
}
