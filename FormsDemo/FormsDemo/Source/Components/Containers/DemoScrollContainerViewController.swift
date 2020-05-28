//
//  DemoScrollContainerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import UIKit

// MARK: DemoScrollContainerViewController
class DemoScrollContainerViewController: FormsViewController {
    private let horizontalScroll = Components.container.scroll()
        .with(paddingHorizontal: 8)
        .with(scrollDirection: .horizontal)
        .with(spacing: 8)
    private let verticalScroll = Components.container.scroll()
        .with(paddingBottom: 24)
        .with(scrollDirection: .vertical)
        .with(spacing: 8)
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.horizontalScroll, with: [
            Anchor.to(self.view).top.safeArea.offset(8),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.horizontalScroll).height(100)
        ])
        self.view.addSubview(self.verticalScroll, with: [
            Anchor.to(self.horizontalScroll).topToBottom.offset(8),
            Anchor.to(self.view).centerX,
            Anchor.to(self.view).width(200),
            Anchor.to(self.view).bottom
        ])
        
        self.setupHorizontalItems(count: 10)
        self.setupVerticalItems(count: 10)
    }
    
    private func setupHorizontalItems(count: Int) {
        let items: [FormsComponent] = (0..<count).map { _ in
            return Components.container.view()
                .with(backgroundColor: Theme.Colors.red)
                .with(anchors: {[
                    Anchor.to($0).width(100),
                    Anchor.to($0).height(100)
                    ]})
        }
        self.horizontalScroll.setItems(items)
    }
    
    private func setupVerticalItems(count: Int) {
        let items: [FormsComponent] = (0..<count).map { _ in
            return Components.container.view()
                .with(backgroundColor: Theme.Colors.green)
                .with(anchors: {[
                    Anchor.to($0).width(200),
                    Anchor.to($0).height(100)
                    ]})
        }
        self.verticalScroll.setItems(items)
    }
}
