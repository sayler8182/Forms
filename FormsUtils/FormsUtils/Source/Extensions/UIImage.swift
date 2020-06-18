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
    
    var isOpaque: Bool {
        return ![
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
    
    func circled() -> UIImage {
        var image: UIImage = self
        let radius: CGFloat = min(self.size.width, self.size.height) / 2.0
        if self.size.width != self.size.height {
            let size: CGFloat = min(self.size.width, self.size.height)
            image = image.scaled(toFill: CGSize(width: size, height: size))
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, self.isOpaque, self.scale)
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: image.size),
            cornerRadius: radius)
        path.addClip()
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        image = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return image
    }
    
    func filtered(name: String,
                  parameters: [String: Any] = [:]) -> UIImage {
        var _image: CIImage? = self.ciImage
        if _image == nil, let cgImage = self.cgImage {
            _image = CIImage(cgImage: cgImage)
        }
        guard let image: CIImage = _image else { return self }
        let context = CIContext(options: [.priorityRequestLow: true])
        var parameters: [String: Any] = parameters
        parameters[kCIInputImageKey] = image
        guard let filter: CIFilter = CIFilter(name: name, parameters: parameters) else { return self }
        guard let output: CIImage = filter.outputImage else { return self }
        guard let cgImage: CGImage = context.createCGImage(output, from: output.extent) else { return self }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func rounded(radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, self.isOpaque, self.scale)
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: self.size),
            cornerRadius: radius)
        path.addClip()
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
    
    func scaled(toFit size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }
        let oldRatio: CGFloat = self.size.width / self.size.height
        let newRatio: CGFloat = size.width / size.height
        let factor: CGFloat = oldRatio > newRatio
            ? size.width / self.size.width
            : size.height / self.size.height
        let newSize: CGSize = CGSize(
            width: self.size.width * factor,
            height: self.size.height * factor)
        let newOrigin = CGPoint(
            x: (size.width - newSize.width) / 2.0,
            y: (size.height - newSize.height) / 2.0)
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, self.scale)
        self.draw(in: CGRect(origin: newOrigin, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func scaled(toFill size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }
        let oldRatio: CGFloat = self.size.width / self.size.height
        let newRatio: CGFloat = size.width / size.height
        let factor: CGFloat = oldRatio > newRatio
            ? size.height / self.size.height
            : size.width / self.size.width
        let newSize = CGSize(
            width: self.size.width * factor,
            height: self.size.height * factor)
        let newOrigin = CGPoint(
            x: (size.width - newSize.width) / 2.0,
            y: (size.height - newSize.height) / 2.0)
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, self.scale)
        self.draw(in: CGRect(origin: newOrigin, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func tinted(_ color: UIColor) -> UIImage {
        var image: UIImage = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
    
    func tinted(_ color: UIColor,
                blend: CGBlendMode) -> UIImage {
        let image: UIImage = self
        let imageColored: UIImage = image.tinted(color)
        let rect: CGRect = CGRect(origin: CGPoint.zero, size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return self }
        context.clear(rect)
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(rect)
        image.draw(in: rect, blendMode: .normal, alpha: 1)
        imageColored.draw(in: rect, blendMode: .multiply, alpha: 1)
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return result
    }
}
