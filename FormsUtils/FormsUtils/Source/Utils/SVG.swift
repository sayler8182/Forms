//
//  SVG.swift
//  FormsUtils
//
//  Created by Konrad on 6/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreGraphics
import UIKit

// MARK: UIBezierPath
public extension UIBezierPath {
    convenience init(svg path: String) {
        let path = SVG.Path(path)
        self.init(svg: path)
    }

    convenience init(svg path: SVG.Path) {
        self.init()
        self.add(path: path)
    }
    
    private func add(path: SVG.Path) {
        for command in path.commands {
            switch command.type {
            case .move: self.move(to: command.point)
            case .line: self.addLine(to: command.point)
            case .quadCurve: self.addQuadCurve(to: command.point, controlPoint: command.control1)
            case .cubeCurve: self.addCurve(to: command.point, controlPoint1: command.control1, controlPoint2: command.control2)
            case .close: self.close()
            }
        }
    }
}

// MARK: SVG
public enum SVG {
    private static let numberSet = "-.0123456789eE"
    
    public enum Coordinates {
        case absolute
        case relative
    }
    
    public class Path: CustomDebugStringConvertible {
        public private (set) var commands: [Command] = []
        private var builder: SVG.Command.Builder = SVG.Command.move
        private var coordinates: Coordinates = .absolute
        private var increment: Int = 2
        private var numbers: String = ""
        
        public init(_ string: String) {
            for char in string {
                switch char {
                case "M": self.use(.absolute, 2, SVG.Command.move)
                case "m": self.use(.relative, 2, SVG.Command.move)
                case "L": self.use(.absolute, 2, SVG.Command.line)
                case "l": self.use(.relative, 2, SVG.Command.line)
                case "V": self.use(.absolute, 1, SVG.Command.lineVertical)
                case "v": self.use(.relative, 1, SVG.Command.lineVertical)
                case "H": self.use(.absolute, 1, SVG.Command.lineHorizontal)
                case "h": self.use(.relative, 1, SVG.Command.lineHorizontal)
                case "Q": self.use(.absolute, 4, SVG.Command.quadBroken)
                case "q": self.use(.relative, 4, SVG.Command.quadBroken)
                case "T": self.use(.absolute, 2, SVG.Command.quadSmooth)
                case "t": self.use(.relative, 2, SVG.Command.quadSmooth)
                case "C": self.use(.absolute, 6, SVG.Command.cubeBroken)
                case "c": self.use(.relative, 6, SVG.Command.cubeBroken)
                case "S": self.use(.absolute, 4, SVG.Command.cubeSmooth)
                case "s": self.use(.relative, 4, SVG.Command.cubeSmooth)
                case "Z": self.use(.absolute, 1, SVG.Command.close)
                case "z": self.use(.absolute, 1, SVG.Command.close)
                default: self.numbers.append(char)
                }
            }
            self.applyCommand()
        }
        
        private func use(_ coordinates: Coordinates,
                         _ increment: Int,
                         _ builder: @escaping SVG.Command.Builder) {
            self.applyCommand()
            self.builder = builder
            self.coordinates = coordinates
            self.increment = increment
        }
        
        private func applyCommand() {
            let numbers: [CGFloat] = SVG.Path.numbers(string: self.numbers)
            let commands: [SVG.Command] = SVG.Command.build(
                numbers: numbers,
                increment: self.increment,
                coordinates: self.coordinates,
                last: self.commands.last,
                builder: self.builder)
            for command in commands {
                switch self.coordinates {
                case .relative:
                    let relative = command.relative(to: self.commands.last)
                    self.commands.append(relative)
                case .absolute:
                    self.commands.append(command)
                }
            }
            self.numbers = ""
        }
        
        private static func numbers(string: String) -> [CGFloat] {
            var result: [String] = []
            var current: String = ""
            var last: String = ""
            
            for char in string {
                if char == "-" && last.isNotEmpty && last != "E" && last != "e" {
                    if current.isNotEmpty {
                        result.append(current)
                    }
                    current = char.asString
                } else if SVG.numberSet.contains(char) {
                    current += char.asString
                } else if current.isNotEmpty {
                    result.append(current)
                    current = ""
                }
                last = char.asString
            }
            result.append(current)
            return result.compactMap { $0.asCGFloat }
        }
        
        public var debugDescription: String {
            var string: String = ""
            string += "let path = UIBezierPath()"
            for command in self.commands {
                string += "\n\(command.debugDescription)"
            }
            return string
        }
    }
    
    public struct Command: CustomDebugStringConvertible {
        public typealias Builder = ([CGFloat], SVG.Command?, Coordinates) -> SVG.Command
        
        public enum CommandType {
            case move
            case line
            case cubeCurve
            case quadCurve
            case close
        }
        
        public var point: CGPoint = CGPoint()
        public var control1: CGPoint = CGPoint()
        public var control2: CGPoint = CGPoint()
        public var type: CommandType = .close
        
        public init() { }
        
        public init(x: CGFloat,
                    y: CGFloat,
                    type: CommandType) {
            self.point = CGPoint(x: x, y: y)
            self.control1 = CGPoint(x: x, y: y)
            self.control2 = CGPoint(x: x, y: y)
            self.type = type
        }
        
        public init(cx: CGFloat,
                    cy: CGFloat,
                    x: CGFloat,
                    y: CGFloat) {
            self.point = CGPoint(x: x, y: y)
            self.control1 = CGPoint(x: cx, y: cy)
            self.control2 = CGPoint(x: cx, y: cy)
            self.type = .quadCurve
        }
        
        public init(cx1: CGFloat,
                    cy1: CGFloat,
                    cx2: CGFloat,
                    cy2: CGFloat,
                    x: CGFloat,
                    y: CGFloat) {
            self.point = CGPoint(x: x, y: y)
            self.control1 = CGPoint(x: cx1, y: cy1)
            self.control2 = CGPoint(x: cx2, y: cy2)
            self.type = .cubeCurve
        }
        
        public init(point: CGPoint,
                    control1: CGPoint,
                    control2: CGPoint,
                    type: CommandType) {
            self.point = point
            self.control1 = control1
            self.control2 = control2
            self.type = type
        }
        
        public func relative(to other: Command?) -> Command {
            guard let point: CGPoint = other?.point else { return self }
            return Command(
                point: self.point + point,
                control1: self.control1 + point,
                control2: self.control2 + point,
                type: self.type)
        }
        
        public var debugDescription: String {
            var string: String = ""
            string += "path."
            switch self.type {
            case .move:
                string += "move(\n\tto: CGPoint(x: \(self.point.x), y: \(self.point.x)))"
            case .line:
                string += "addLine(\n\tto: CGPoint(x: \(self.point.x), y: \(self.point.x)))"
            case .cubeCurve:
                string += "addQuadCurve(\n\tto: CGPoint(x: \(self.point.x), y: \(self.point.x)), \n\tcontrolPoint: CGPoint(x: \(self.control1.x), y: \(self.control1.x)))"
            case .quadCurve:
                string += "addCurve(\n\tto: CGPoint(x: \(self.point.x), y: \(self.point.x)), \n\tcontrolPoint1: CGPoint(x: \(self.control1.x), y: \(self.control1.x)), \n\tcontrolPoint2: CGPoint(x: \(self.control2.x), y: \(self.control2.x)))"
            case .close:
                string += "close()"
            }
            return string
        }
    }
}

// MARK: Builder
extension SVG.Command {
    static func build(numbers: [CGFloat],
                      increment: Int,
                      coordinates: SVG.Coordinates,
                      last: SVG.Command?,
                      builder: SVG.Command.Builder) -> [SVG.Command] {
        guard numbers.isNotEmpty || increment != 1 else {
            return [SVG.Command()]
        }
        var result: [SVG.Command] = []
        var lastCommand: SVG.Command? = last
        let count: Int = (numbers.count / increment) * increment
        var nums: [CGFloat] = [0, 0, 0, 0, 0, 0]
        
        for i in stride(from: 0, to: count, by: increment) {
            for j in 0 ..< increment {
                nums[j] = numbers[i + j]
            }
            let command: SVG.Command = builder(nums, lastCommand, coordinates)
            result.append(command)
            lastCommand = command
        }
        
        return result
    }
    
    // MARK: Mm - Move
    static func move(numbers: [CGFloat],
                     last: SVG.Command?,
                     coordinates: SVG.Coordinates) -> SVG.Command {
        return SVG.Command(
            x: numbers[0],
            y: numbers[1],
            type: .move)
    }
    
    // MARK: Ll - Line
    static func line(numbers: [CGFloat],
                     last: SVG.Command?,
                     coordinates: SVG.Coordinates) -> SVG.Command {
        return SVG.Command(
            x: numbers[0],
            y: numbers[1],
            type: .line)
    }
    
    // MARK: Vv - Vertical Line
    static func lineVertical(numbers: [CGFloat],
                             last: SVG.Command?,
                             coordinates: SVG.Coordinates) -> SVG.Command {
        let x: CGFloat = coordinates == .absolute
            ? last?.point.x ?? 0
            : 0
        return SVG.Command(
            x: x,
            y: numbers[0],
            type: .line)
    }
    
    // MARK: Hh - Horizontal Line
    static func lineHorizontal(numbers: [CGFloat],
                               last: SVG.Command?,
                               coordinates: SVG.Coordinates) -> SVG.Command {
        let y: CGFloat = coordinates == .absolute
            ? last?.point.y ?? 0
            : 0
        return SVG.Command(
            x: numbers[0],
            y: y,
            type: .line)
    }
    
    // MARK: Qq - Quadratic Curve To
    static func quadBroken(numbers: [CGFloat],
                           last: SVG.Command?,
                           coordinates: SVG.Coordinates) -> SVG.Command {
        return SVG.Command(
            cx: numbers[0],
            cy: numbers[1],
            x: numbers[2],
            y: numbers[3])
    }
    
    // MARK: Tt - Smooth Quadratic Curve To
    static func quadSmooth(numbers: [CGFloat],
                           last: SVG.Command?,
                           coordinates: SVG.Coordinates) -> SVG.Command {
        var lastControl: CGPoint = last?.control1 ?? CGPoint()
        let lastPoint: CGPoint = last?.point ?? CGPoint()
        if last?.type != .quadCurve {
            lastControl = lastPoint
        }
        var control: CGPoint = lastPoint - lastControl
        if coordinates == .absolute {
            control += lastPoint
        }
        return SVG.Command(
            cx: control.x,
            cy: control.y,
            x: numbers[0],
            y: numbers[1])
    }
    
    // MARK: Cc - Cubic Curve To
    static func cubeBroken(numbers: [CGFloat],
                           last: SVG.Command?,
                           coordinates: SVG.Coordinates) -> SVG.Command {
        return SVG.Command(
            cx1: numbers[0],
            cy1: numbers[1],
            cx2: numbers[2],
            cy2: numbers[3],
            x: numbers[4],
            y: numbers[5])
    }
    
    // MARK: Ss - Smooth Cubic Curve To
    static func cubeSmooth(numbers: [CGFloat],
                           last: SVG.Command?,
                           coordinates: SVG.Coordinates) -> SVG.Command {
        var lastControl: CGPoint = last?.control2 ?? CGPoint()
        let lastPoint: CGPoint = last?.point ?? CGPoint()
        if last?.type != .cubeCurve {
            lastControl = lastPoint
        }
        var control: CGPoint = lastPoint - lastControl
        if coordinates == .absolute {
            control += lastPoint
        }
        return SVG.Command(
            cx1: control.x,
            cy1: control.y,
            cx2: numbers[0],
            cy2: numbers[1],
            x: numbers[2],
            y: numbers[3])
    }
    
    // MARK: Zz - Close Path
    static func close(numbers: [CGFloat],
                      last: SVG.Command?,
                      coordinates: SVG.Coordinates) -> SVG.Command {
        return SVG.Command()
    }
}

// MARK: SVGView
public protocol SVGView: class {
    var svgLayer: CAShapeLayer? { get set }
}
public extension SVGView {
    func with(svg: String) -> Self {
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = UIBezierPath(svg: svg).cgPath
        self.svgLayer = layer
        return self
    }
    func with(svgBackgroundColor: CGColor?) -> Self {
        self.svgLayer?.backgroundColor = svgBackgroundColor
        return self
    }
    func with(svgFillColor: CGColor?) -> Self {
        self.svgLayer?.fillColor = svgFillColor
        return self
    }
    func with(svgLayer: CAShapeLayer?) -> Self {
        self.svgLayer = svgLayer
        return self
    }
    func with(svgLineWidth: CGFloat) -> Self {
        self.svgLayer?.lineWidth = svgLineWidth
        return self
    }
    func with(svgStrokeColor: CGColor?) -> Self {
        self.svgLayer?.strokeColor = svgStrokeColor
        return self
    }
}
