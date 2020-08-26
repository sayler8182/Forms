//
//  UIColor.swift
//  FormsUtils
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

// MARK: UIColor
public extension UIColor {
    var transparent: UIColor {
        return self.withAlphaComponent(0.0)
    }
    
    var image: UIImage? {
        return UIImage(color: self)
    }
    
    convenience init(rgbDark: Int,
                     _ darkAlpha: Int = 100,
                     rgbLight: Int,
                     _ lightAlpha: Int = 100) {
        if #available(iOS 13.0, *) {
            self.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark
                    ? UIColor(rgbDark, darkAlpha)
                    : UIColor(rgbLight, lightAlpha)
            }
        } else {
            self.init(rgbLight, lightAlpha)
        }
    }
    
    convenience init(rgbaDark: UInt,
                     rgbaLight: UInt) {
        if #available(iOS 13.0, *) {
            self.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark
                    ? UIColor(rgba: rgbaDark)
                    : UIColor(rgba: rgbaLight)
            }
        } else {
            self.init(rgba: rgbaLight)
        }
    }
    
    convenience init(_ rgb: Int,
                     _ alpha: Int = 100) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha)
    }
    
    convenience init(rgba: UInt) {
        self.init(
            red: Int((rgba >> 24) & 0xFF),
            green: Int((rgba >> 16) & 0xFF),
            blue: Int((rgba >> 8) & 0xFF),
            alpha: Int(rgba & 0xFF))
    }
    
    private convenience init(red: Int,
                             green: Int,
                             blue: Int,
                             alpha: Int = 100) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 100.0)
    }
    
    func with(alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}

// MARK: Gradient
public extension UIColor {
    private static var gradientImageKey: UInt8 = 0
    
    enum GradientStyle {
        case linearHorizontal
        case linearVertical
        case radial
    }
    
    private var gradientImage: UIImage? {
        get { return getObject(self, &Self.gradientImageKey) }
        set { setObject(self, &Self.gradientImageKey, newValue) }
    }
    
    convenience init?(style: GradientStyle,
                      frame: CGRect,
                      colors: [UIColor?]) {
        self.init(
            style: style,
            frame: frame,
            colors: colors.compactMap { $0 })
    }
    convenience init?(style: GradientStyle,
                      frame: CGRect,
                      colors: [UIColor]) {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = frame
        let colors: [CGColor] = colors.map { $0.cgColor }
         
        switch style {
        case .linearHorizontal:
            defer { UIGraphicsEndImageContext() }
            layer.colors = colors
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
            guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)
            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            self.init(patternImage: image)
            self.gradientImage = image
        
        case .linearVertical:
            defer { UIGraphicsEndImageContext() }
            layer.colors = colors
            layer.startPoint = CGPoint(x: 0.5, y: 0.0)
            layer.endPoint = CGPoint(x: 0.5, y: 1.0)
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
            guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)
            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            self.init(patternImage: image)
            self.gradientImage = image
            
        case .radial:
            defer { UIGraphicsEndImageContext() }
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
            var locations: [CGFloat] = [0.0, 1.0]
            let colorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
            let cfColors: CFArray = colors as CFArray
            guard let gradient: CGGradient = CGGradient(
                colorsSpace: colorspace,
                colors: cfColors,
                locations: &locations) else { return nil }
            let centerPoint: CGPoint = CGPoint(
                x: 0.5 * frame.size.width,
                y: 0.5 * frame.size.height)
            let radius: CGFloat = min(frame.size.width, frame.size.height) * 0.5
            guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
            context.drawRadialGradient(
                gradient,
                startCenter: centerPoint,
                startRadius: 0,
                endCenter: centerPoint,
                endRadius: radius,
                options: .drawsAfterEndLocation)
            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            self.init(patternImage: image)
            self.gradientImage = image
        }
    }
}
