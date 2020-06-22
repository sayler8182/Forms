//
//  CodeGenerator.swift
//  FormsUtils
//
//  Created by Konrad on 6/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreImage
import UIKit

public extension CodeGenerator {
    // MARK: CodeType
    enum CodeType {
        case aztecCode
        case checkerboard
        case code128Barcode
        case constantColor
        case lenticularHalo
        case pdf417Barcode
        case qrCode(CorrectionLevel)
        case random
        case starShine
        case stripes
        case sunbeams
        
        var name: String {
            switch self {
            case .aztecCode: return "CIAztecCodeGenerator"
            case .checkerboard: return "CICheckerboardGenerator"
            case .code128Barcode: return "CICode128BarcodeGenerator"
            case .constantColor: return "CIConstantColorGenerator"
            case .lenticularHalo: return "CILenticularHaloGenerator"
            case .pdf417Barcode: return "CIPDF417BarcodeGenerator"
            case .qrCode: return "CIQRCodeGenerator"
            case .random: return "CIRandomGenerator"
            case .starShine: return "CIStarShineGenerator"
            case .stripes: return "CIStripesGenerator"
            case .sunbeams: return "CISunbeamsGenerator"
            }
        }
    }
    
    // MARK: CorrectionLevel
    enum CorrectionLevel: String {
        case l = "L"
        case m = "M"
        case q = "Q"
        case h = "H"
    }
}

// MARK: CodeGeneratorRequest
public class CodeGeneratorRequest {
    public var code: String = ""
    public var background: UIColor = UIColor.clear
    public var foreground: UIColor = UIColor.black
    public var size: CGSize = CGSize(width: 100.0, height: 100.0)
    
    public init() { }
    
    public init(code: String) {
        self.code = code
    }
}

// MARK: Builder
public extension CodeGeneratorRequest {
    func with(code: String) -> Self {
        self.code = code
        return self
    }
    func with(background: UIColor) -> Self {
        self.background = background
        return self
    }
    func with(foreground: UIColor) -> Self {
        self.foreground = foreground
        return self
    }
    func with(size: CGSize) -> Self {
        self.size = size
        return self
    }
}

// MARK: CodeGenerator
public class CodeGenerator {
    public let type: CodeType
    
    public init(type: CodeType) {
        self.type = type
    }

    public func image(request: CodeGeneratorRequest) -> UIImage? {
        guard let data: Data = request.code.data(using: .ascii) else { return nil }
        guard let filter: CIFilter = CIFilter(name: self.type.name) else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        self.setValues(filter)
        guard var ciImage: CIImage = filter.outputImage else { return nil }
        ciImage = self.transformColor(ciImage, request)
        ciImage = self.transformSize(ciImage, request)
        return UIImage(ciImage: ciImage)
    }
    
    private func setValues(_ filter: CIFilter) {
        switch self.type {
        case .aztecCode: break
        case .checkerboard: break
        case .code128Barcode: break
        case .constantColor: break
        case .lenticularHalo: break
        case .pdf417Barcode: break
        case .qrCode(let correctionLevel):
            filter.setValue(correctionLevel.rawValue, forKey: "correctionLevel")
        case .random: break
        case .starShine: break
        case .stripes: break
        case .sunbeams: break
        }
    }
    
    private func transformSize(_ ciImage: CIImage,
                               _ request: CodeGeneratorRequest) -> CIImage {
        let scaleX: CGFloat = request.size.width / ciImage.extent.size.width
        let scaleY: CGFloat = request.size.height / ciImage.extent.size.height
        let transform: CGAffineTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        return ciImage.transformed(by: transform)
    }
    
    private func transformColor(_ ciImage: CIImage,
                                _ request: CodeGeneratorRequest) -> CIImage {
        return ciImage.applyingFilter("CIFalseColor", parameters: [
            "inputColor0": CIColor(color: request.foreground),
            "inputColor1": CIColor(color: request.background)
        ])
    }
}

// MARK: String
public extension String {
    func code(type: CodeGenerator.CodeType,
              request: CodeGeneratorRequest) -> UIImage? {
        let codeGenerator: CodeGenerator = CodeGenerator(type: type)
        request.code = self
        return codeGenerator.image(request: request)
    }
}
