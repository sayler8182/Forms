//
//  LoremIpsum.swift
//  FormsUtilsUI
//
//  Created by Konrad on 6/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

extension LoremIpsum {
    static func empty(lines: Double,
                      label: UILabel) -> String {
        return LoremIpsum.empty(
            lines: lines,
            font: label.font,
            width: label.frame.width)
    }
    static func empty(lines: Double,
                      font: UIFont,
                      width: CGFloat) -> String {
        let size: CGSize = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude)
        let text: String = LoremIpsum.empty(chars: 1)
        let boundingBox: CGRect = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        let charsInLine: CGFloat = width / boundingBox.width
        let totalChars: Int = (charsInLine.asDouble * lines).ceiled.asInt
        return LoremIpsum.empty(chars: totalChars)
    }
}
