//
//  AttributedString.swift
//  FormsUtils
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Part
public extension AttributedString {
    typealias Action = (() -> Void)
    
    class Part {
        public let position: NSRange
        public let onClick: Action?
        
        init(position: NSRange,
             onClick: Action?) {
            self.position = position
            self.onClick = onClick
        }
    }
    
    class Style: NSCopying {
        var alignment: NSTextAlignment? = nil
        var baselineOffset: CGFloat? = nil
        var color: UIColor? = nil
        var font: UIFont? = nil
        var lineHeightMultiple: CGFloat? = nil
        var lineSpacing: CGFloat? = nil
        var lineBreakMode: NSLineBreakMode? = nil
        var underlineStyle: NSUnderlineStyle? = nil
        
        public func copy(with zone: NSZone? = nil) -> Any {
            let copy: Style = Style()
            copy.alignment = self.alignment
            copy.baselineOffset = self.baselineOffset
            copy.color = self.color
            copy.font = self.font
            copy.lineHeightMultiple = self.lineHeightMultiple
            copy.lineSpacing = self.lineSpacing
            copy.lineBreakMode = self.lineBreakMode
            copy.underlineStyle = self.underlineStyle
            return copy
        }
    }
}

// MARK: AttributedString
public class AttributedString {
    public private (set) var string = NSMutableAttributedString()
    public weak var label: UILabel? = nil
    private var style = Style()
    private var nextStyle: Style? = nil
    private var parts: [Part] = []
    private static var textView: UITextView = {
        let textView = UITextView()
        AttributedString.configureTextView(textView: textView)
        return textView
    }()
    
    public init() { }
    
    private func savePart(string: NSAttributedString?,
                          onClick: Action? = nil) {
        guard let string: NSAttributedString = string else { return }
        let part: Part = Part(
            position: NSRange(location: self.string.length, length: string.length),
            onClick: onClick)
        self.parts.append(part)
    }
    
    private func savePart(string: String?,
                          onClick: Action? = nil) {
        guard let string: String = string else { return }
        let part: Part = Part(
            position: NSRange(location: self.string.length, length: string.count),
            onClick: onClick)
        self.parts.append(part)
    }
    
    private func savePart(attachment: NSTextAttachment?,
                          onClick: Action? = nil) {
        let part: Part = Part(
            position: NSRange(location: self.string.length, length: 0),
            onClick: onClick)
        self.parts.append(part)
    }
    
    public func with(string: String?,
                     onClick: Action? = nil) -> AttributedString {
        guard let string: String = string else { return self }
        let style: Style = self.nextStyle ?? self.style
        let attributedString = NSMutableAttributedString(string: string)
            .with(alignment: style.alignment)
            .with(baselineOffset: style.baselineOffset)
            .with(color: style.color)
            .with(font: style.font)
            .with(lineHeightMultiple: style.lineHeightMultiple)
            .with(lineSpacing: style.lineSpacing)
            .with(lineBreakMode: style.lineBreakMode)
            .with(underlineStyle: style.underlineStyle)
        return self.with(string: attributedString, onClick: onClick)
    }
    
    public func with(string: NSAttributedString?,
                     onClick: Action? = nil) -> AttributedString {
        guard let string: NSAttributedString = string else { return self }
        self.savePart(string: string, onClick: onClick)
        self.string = self.string.with(string: string)
        self.nextStyle = nil
        return self
    }
    
    public func switchStyle() -> AttributedString {
        self.nextStyle = self.style.copy() as? Style
        return self
    }
    
    public func with(attachment: NSTextAttachment?,
                     onClick: Action? = nil) -> AttributedString {
        self.savePart(attachment: attachment, onClick: onClick)
        self.string.with(attachment: attachment)
        return self
    }
    
    public func with(alignment: NSTextAlignment?) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.alignment = alignment
        return self
    }
       
    public func with(baselineOffset: CGFloat?) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.baselineOffset = baselineOffset
        return self
    }
    
    public func with(color: UIColor) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.color = color
        return self
    }
    
    public func with(font: UIFont) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.font = font
        return self
    }
    
    public func with(lineHeightMultiple: CGFloat?) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.lineHeightMultiple = lineHeightMultiple
        return self
    }
    
    public func with(lineSpacing: CGFloat?) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.lineSpacing = lineSpacing
        return self
    }
    
    public func with(lineBreakMode: NSLineBreakMode?) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.lineBreakMode = lineBreakMode
        return self
    }
       
    public func with(underlineStyle: NSUnderlineStyle?) -> AttributedString {
        let style: Style = self.nextStyle ?? self.style
        style.underlineStyle = underlineStyle
        return self
    }
}

// MARK: AttributedString - Tappable
public extension AttributedString {
    private static func configureTextView(textView: UITextView) {
        let textView = UITextView()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.backgroundColor = nil
    }
    
    func attributedStringPart(recognizer: UIGestureRecognizer) -> Part? {
        guard let label: UILabel = self.label else { return nil }
        let textView = AttributedString.textView
        textView.frame = label.frame
        textView.attributedText = label.attributedText
        textView.textContainer.lineBreakMode = label.lineBreakMode
        textView.textContainer.maximumNumberOfLines = label.numberOfLines
        let pointOfTouchInLabel: CGPoint = recognizer.location(in: label)
        let index = textView.layoutManager.characterIndex(
            for: pointOfTouchInLabel, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let part: Part? = self.parts
            .first(where: { $0.onClick.isNotNil && $0.position.contains(index) })
        return part
    }
}

// MARK: NSAttributedString
public extension NSAttributedString {
    var mutable: NSMutableAttributedString {
        guard let mutable: NSMutableAttributedString = self as? NSMutableAttributedString else {
            return NSMutableAttributedString(attributedString: self)
        }
        return mutable
    }
    
    convenience init(string: String?) {
        let string: String = string ?? ""
        self.init(string: string)
    }
}

// MARK: NSAttributedString
public extension NSAttributedString {
    @discardableResult
    func with(string: NSAttributedString?) -> NSMutableAttributedString {
        let mutable: NSMutableAttributedString = self.mutable
        guard let string: NSAttributedString = string else { return mutable }
        mutable.append(string)
        return mutable
    }
    
    @discardableResult
    func with(string: String?) -> NSMutableAttributedString {
        let mutable: NSMutableAttributedString = self.mutable
        guard let string: String = string else { return mutable }
        mutable.append(NSMutableAttributedString(string: string))
        return mutable
    }
    
    @discardableResult
    func with(attachment: NSTextAttachment?) -> NSMutableAttributedString {
        let mutable: NSMutableAttributedString = self.mutable
        guard let attachment: NSTextAttachment = attachment else { return mutable }
        mutable.append(NSMutableAttributedString(attachment: attachment))
        return mutable
    }
}

// MARK: NSAttributedString
public extension NSAttributedString {
    func attribute<T>(key: NSAttributedString.Key,
                      of type: T.Type) -> T? {
        guard self.string.isNotEmpty else { return nil }
        let attributes: [NSAttributedString.Key: Any] = self.attributes(at: 0, effectiveRange: nil)
        return attributes[key] as? T
    }
    
    @discardableResult
    func with(alignment: NSTextAlignment?) -> NSMutableAttributedString {
        let paragraph: NSMutableParagraphStyle = self.attribute(
            key: .paragraphStyle,
            of: NSMutableParagraphStyle.self) ?? NSMutableParagraphStyle()
        paragraph.alignment = alignment ?? .natural
        return self
            .with(key: .paragraphStyle, value: paragraph)
    }
     
    @discardableResult
    func with(baselineOffset: CGFloat?) -> NSMutableAttributedString {
        return self.with(key: .baselineOffset, value: baselineOffset?.asNumber)
    }
    
    @discardableResult
    func with(color: UIColor?) -> NSMutableAttributedString {
        return self.with(key: .foregroundColor, value: color)
    }
    
    @discardableResult
    func with(font: UIFont?) -> NSMutableAttributedString {
        return self.with(key: .font, value: font)
    }
     
    @discardableResult
    func with(lineHeightMultiple: CGFloat?) -> NSMutableAttributedString {
        let paragraph: NSMutableParagraphStyle = self.attribute(
            key: .paragraphStyle,
            of: NSMutableParagraphStyle.self) ?? NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = lineHeightMultiple ?? 0.0
        return self
            .with(key: .paragraphStyle, value: paragraph)
    }
    
    @discardableResult
    func with(lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let paragraph: NSMutableParagraphStyle = self.attribute(
            key: .paragraphStyle,
            of: NSMutableParagraphStyle.self) ?? NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = lineSpacing ?? 0.0
        return self
            .with(key: .paragraphStyle, value: paragraph)
    }
    
    @discardableResult
    func with(lineBreakMode: NSLineBreakMode?) -> NSMutableAttributedString {
        let paragraph: NSMutableParagraphStyle = self.attribute(
            key: .paragraphStyle,
            of: NSMutableParagraphStyle.self) ?? NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreakMode ?? .byTruncatingTail
        return self
            .with(key: .paragraphStyle, value: paragraph)
    }
    
    @discardableResult
    func with(underlineStyle: NSUnderlineStyle?) -> NSMutableAttributedString {
        return self.with(key: .underlineStyle, value: underlineStyle?.rawValue)
    }
    
    private func with(key: NSAttributedString.Key,
                      value: Any?) -> NSMutableAttributedString {
        let mutable: NSMutableAttributedString = self.mutable
        if let _value: Any = value {
            mutable.addAttribute(
                key,
                value: _value,
                range: NSRange(location: 0, length: mutable.length))
        } else {
            mutable.removeAttribute(
                key,
                range: NSRange(location: 0, length: mutable.length))
        }
        
        return mutable
    }
}

// MARK: NSTextAttachment
public extension NSTextAttachment {
    convenience init(image: UIImage?,
                     bounds: CGRect) {
        self.init()
        self.image = image
        self.bounds = bounds
    }
}

// MARK: NSAttributedString - size
public extension NSAttributedString {
    func height(width: CGFloat) -> CGFloat {
        let constraintRect: CGSize = CGSize(
            width: width,
            height: CGFloat.greatestFiniteMagnitude)
        let boundingBox: CGRect = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(height: CGFloat) -> CGFloat {
        let constraintRect: CGSize = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: height)
        let boundingBox: CGRect = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil)
        return ceil(boundingBox.width)
    }
}

// MARK: NSTextAlignment
public extension NSTextAlignment {
    static var notNatural: NSTextAlignment {
        return UIView.isRightToLeft ? .left : .right
    }
}
