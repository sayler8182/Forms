//
//  UIImageView.swift
//  FormsUtils
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

// MARK: UIImageView - SVG
extension UIImageView: SVGView {
    private static var svgLayerViewKey: UInt8 = 0
    private static var svgLayerKey: UInt8 = 0
    
    private var svgLayerView: UIView? {
        get { return getObject(self, &Self.svgLayerViewKey) }
        set { setObject(self, &Self.svgLayerViewKey, newValue) }
    }
    public var svgLayer: CAShapeLayer? {
        get { return getObject(self, &Self.svgLayerKey) }
        set {
            let oldValue: CAShapeLayer? = self.svgLayer
            setObject(self, &Self.svgLayerKey, newValue)
            self.updateSVGLayer(oldLayer: oldValue, newLayer: newValue)
        }
    } 
    
    private func updateSVGLayer(oldLayer: CALayer?,
                                newLayer: CALayer?) {
        self.svgLayerView?.removeFromSuperview()
        self.svgLayerView = nil
        guard let newLayer: CALayer = newLayer else { return }
        let view = LayerView(newLayer)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.addSublayer(newLayer)
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        self.svgLayerView = view
    }
}

// MARK: LayerView
private class LayerView: UIView {
    private var svgLayer: CALayer?
    
    init(_ svgLayer: CALayer) {
        self.init()
        self.svgLayer = svgLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.svgLayer = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.svgLayer = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.updateLayer()
    }
    
    private func updateLayer() {
        guard let layer: CALayer = self.svgLayer else { return }
        layer.frame = self.bounds
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        guard let path: CGPath = shapeLayer.path else { return }
        let bounds: CGRect = path.boundingBox
        let bezierPath = UIBezierPath(cgPath: path)
        bezierPath.apply(CGAffineTransform(
            scaleX: self.bounds.width / bounds.width,
            y: self.bounds.height / bounds.height))
        shapeLayer.path = bezierPath.cgPath
    }
}

// MARK: Builder
public extension UIImageView {
    func with(image color: UIColor) -> Self {
        self.image = UIImage(color: color)
        return self
    }
    func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }
}
