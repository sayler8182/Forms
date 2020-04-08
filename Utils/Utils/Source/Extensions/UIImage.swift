//
//  UIImage.swift
//  Utils
//
//  Created by Konrad on 4/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public extension UIImage {
    var asTemplate: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
