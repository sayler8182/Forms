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
    
    // init from color
    convenience init?(color: UIColor) {
        let size: CGSize = CGSize(width: 1, height: 1)
        let scale: CGFloat = 1.0
        let rect: CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
