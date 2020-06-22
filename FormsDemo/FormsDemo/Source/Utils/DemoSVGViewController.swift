//
//  DemoSVGViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: DemoSVGViewController
class DemoSVGViewController: FormsTableViewController {
    private lazy var svgFromStringImageView = Components.image.default()
        .with(height: 200)
        .with(svg: self.svg)
        .with(svgBackgroundColor: Theme.Colors.secondaryLight.cgColor)
        .with(svgFillColor: Theme.Colors.blue.cgColor)
        .with(svgStrokeColor: Theme.Colors.primaryDark.cgColor)
    private lazy var svgFromStringLabel = Components.label.default()
        .with(numberOfLines: 0)
        .with(text: SVG.Path(self.svg).debugDescription)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private let svg: String = "M85 32C115 68 239 170 281 192 311 126 274 43 244 0c97 58 146 167 121 254 28 28 40 89 29 108 -25-45-67-39-93-24C176 409 24 296 0 233c68 56 170 65 226 27C165 217 56 89 36 54c42 38 116 96 161 122C159 137 108 72 85 32z"
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.svgFromStringImageView,
            self.svgFromStringLabel
        ], divider: self.divider)
    }
}
