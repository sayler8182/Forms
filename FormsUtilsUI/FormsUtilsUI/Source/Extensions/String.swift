//
//  String.swift
//  FormsUtils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: String
public extension String {
    func height(for width: CGFloat,
                font: UIFont) -> CGFloat {
        let size: CGSize = CGSize(
            width: width,
            height: .greatestFiniteMagnitude)
        let boundingBox: CGRect = self.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(for height: CGFloat,
               font: UIFont) -> CGFloat {
        let size: CGSize = CGSize(
            width: .greatestFiniteMagnitude,
            height: height)
        let boundingBox: CGRect = self.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return ceil(boundingBox.width)
    }
}
