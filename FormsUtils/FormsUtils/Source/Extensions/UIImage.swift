//
//  UIImage.swift
//  FormsUtils
//
//  Created by Konrad on 4/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIImage
public extension UIImage {
    var asTemplate: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
    
    var hasAlphaChannel: Bool {
        return [
            CGImageAlphaInfo.first,
            CGImageAlphaInfo.last,
            CGImageAlphaInfo.premultipliedFirst,
            CGImageAlphaInfo.premultipliedLast
            ].contains(self.cgImage?.alphaInfo)
    }
    
    convenience init?(color: UIColor,
                      size: CGSize = CGSize(width: 1, height: 1),
                      scale: CGFloat = UIScreen.main.scale) {
        let rect: CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    static func from(name: String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: name)
        } else {
            return UIImage(named: name)
        }
    }
    
    func scaledToFill(to size: CGSize,
                      scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let image: UIImage = self
        let imageAspectRatio: CGFloat = image.size.width / image.size.height
        let canvasAspectRatio: CGFloat = size.width / size.height
        
        let resizeFactor: CGFloat = imageAspectRatio > canvasAspectRatio
            ? size.height / image.size.height
            : size.width / image.size.width
        
        let scaledSize: CGSize = CGSize(
            width: image.size.width * resizeFactor,
            height: image.size.height * resizeFactor)
        let origin: CGPoint = CGPoint(
            x: (size.width - scaledSize.width) / 2.0,
            y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, !image.hasAlphaChannel, scale)
        self.draw(in: CGRect(origin: origin, size: scaledSize))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? image
    }
    
    func scaledToFit(to size: CGSize,
                     scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let image: UIImage = self
        let scale: CGFloat = scale
        let imageAspectRatio: CGFloat = image.size.width / image.size.height
        let canvasAspectRatio: CGFloat = size.width / size.height
        
        let resizeFactor: CGFloat = imageAspectRatio > canvasAspectRatio
            ? size.width / image.size.width
            : size.height / image.size.height
        
        let scaledSize: CGSize = CGSize(
            width: image.size.width * resizeFactor,
            height: image.size.height * resizeFactor)
        let origin: CGPoint = CGPoint(
            x: (size.width - scaledSize.width) / 2.0,
            y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, !image.hasAlphaChannel, scale)
        self.draw(in: CGRect(origin: origin, size: scaledSize))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? image
    }
}
