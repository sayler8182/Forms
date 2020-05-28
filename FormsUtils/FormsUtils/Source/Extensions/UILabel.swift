//
//  UILabel.swift
//  FormsUtils
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Label
public extension UILabel {
    func height(for width: CGFloat) -> CGFloat {
        let size: CGSize = CGSize(
            width: width,
            height: .greatestFiniteMagnitude)
        if let text: String = self.text {
            let boundingBox: CGRect = text.boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font!], // swiftlint:disable:this force_unwrapping
                context: nil)
            return ceil(boundingBox.height)
        } else if let attributedText: NSAttributedString = self.attributedText {
            let boundingBox: CGRect = attributedText.boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                context: nil)
            return ceil(boundingBox.height)
        } else {
            return .greatestFiniteMagnitude
        }
    }
    
    func width(for height: CGFloat) -> CGFloat {
        let size: CGSize = CGSize(
            width: .greatestFiniteMagnitude,
            height: height)
        if let text: String = self.text {
            let boundingBox: CGRect = text.boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font!], // swiftlint:disable:this force_unwrapping
                context: nil)
            return ceil(boundingBox.width)
        } else if let attributedText: NSAttributedString = self.attributedText {
            let boundingBox: CGRect = attributedText.boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                context: nil)
            return ceil(boundingBox.width)
        } else {
            return .greatestFiniteMagnitude
        }
    }
}

// MARK: Builder
public extension UILabel {
    func with(font: UIFont) -> Self {
        self.font = font
        return self
    }
    func with(numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    func with(textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    func with(text: String?) -> Self {
        self.text = text
        return self
    }
    func with(textColor: UIColor?) -> Self {
        self.textColor = textColor
        return self
    }
}
