//
//  DemoFontsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoFontsViewController
class DemoFontsViewController: FormsTableViewController {
    private let awesomeLabel = Components.label.default()
        .with(marginVertical: 4, marginHorizontal: 16)
        .with(text: "Awesome")
    private let awesomeValueLabel = Components.label.default()
        .with(font: Font.awesome.font(size: 12))
        .with(marginHorizontal: 16)
        .with(text: "\(FontAwesome.ad)\u{f2b9}")
    private let ionLabel = Components.label.default()
        .with(marginVertical: 4, marginHorizontal: 16)
        .with(text: "Ion")
    private let ionValueLabel = Components.label.default()
        .with(font: Font.ion.font(size: 12))
        .with(marginHorizontal: 16)
        .with(text: "\(FontIon.md_people)\u{f345}")
    private let materialLabel = Components.label.default()
        .with(marginVertical: 4, marginHorizontal: 16)
        .with(text: "Material")
    private let materialValueLabel = Components.label.default()
        .with(font: Font.material.font(size: 12))
        .with(marginHorizontal: 16)
        .with(text: "\(FontMaterial.person)\u{e7fe}")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.awesomeLabel,
            self.awesomeValueLabel,
            self.ionLabel,
            self.ionValueLabel,
            self.materialLabel,
            self.materialValueLabel
        ], divider: self.divider)
    }
}
