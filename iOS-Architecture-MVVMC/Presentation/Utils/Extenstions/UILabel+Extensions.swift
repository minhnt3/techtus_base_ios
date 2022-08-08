//
//  UILabel+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import UIKit

extension UILabel {
    func setLeft() {
        self.textAlignment = .left
    }
    func setRight() {
        self.textAlignment = .right
    }
    var underline: NSUnderlineStyle? {
        get { getAttribute(.underlineStyle) }
        set { setAttribute(.underlineStyle, value: newValue) }
    }
    var strikethrough: NSUnderlineStyle? {
        get { getAttribute(.strikethroughStyle)}
        set { setAttribute(.strikethroughStyle, value: newValue) }
    }
    var lineSpacing: CGFloat? {
        get { paragraphStyle?.lineSpacing }
        set {
            let lineSpacing = newValue ?? 1.0
            addAttribute(
                .paragraphStyle,
                value: (paragraphStyle ?? NSParagraphStyle())
                    .mutable.withProperty(lineSpacing, for: \.lineSpacing))
        }
    }
    var maxLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    var lineHeight: CGFloat? {
        get { paragraphStyle?.maximumLineHeight }
        set {
            let lineHeight = newValue ?? font.lineHeight
            let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0
            addAttribute(.baselineOffset, value: baselineOffset)
            addAttribute(
                .paragraphStyle,
                value: (paragraphStyle ?? NSParagraphStyle())
                    .mutable
                    .withProperty(lineHeight, for: \.minimumLineHeight)
                    .withProperty(lineHeight, for: \.maximumLineHeight)
            )
        }
    }
    var letterSpacing: CGFloat? {
        get { getAttribute(.kern) }
        set { setAttribute(.kern, value: newValue) }
    }
}

fileprivate extension UILabel {
    var paragraphStyle: NSParagraphStyle? {
        getAttribute(.paragraphStyle)
    }
    // Attributes of `attributedText` (if any).
    var attributes: [NSAttributedString.Key: Any]? {
        if let attributedText = attributedText,
           attributedText.length > 0 {
            return attributedText.attributes(at: 0, effectiveRange: nil)
        } else {
            return nil
        }
    }
    // Get attribute for the given key (if any).
    func getAttribute<AttributeType>(
        _ key: NSAttributedString.Key
    ) -> AttributeType? where AttributeType: Any {
        return attributes?[key] as? AttributeType
    }
    func addAttribute(_ key: NSAttributedString.Key, value: Any) {
        attributedText = attributedText?.stringByAddingAttribute(key, value: value)
    }
    func removeAttribute(_ key: NSAttributedString.Key) {
        attributedText = attributedText?.stringByRemovingAttribute(key)
    }
    func setAttribute<AttributeType>(
        _ key: NSAttributedString.Key,
        value: AttributeType?) where AttributeType: Any {
            if let value = value {
                addAttribute(key, value: value)
            } else {
                removeAttribute(key)
            }
        }
}

fileprivate extension UILabel {
    // Get `OptionSet` attribute for the given key (if any).
    func getAttribute<AttributeType>(
        _ key: NSAttributedString.Key
    ) -> AttributeType? where AttributeType: OptionSet {
        if let attribute = attributes?[key] as? AttributeType.RawValue {
            return .init(rawValue: attribute)
        } else {
            return nil
        }
    }
    // Add (or remove) `OptionSet` attribute for the given key (if any).
    func setAttribute<AttributeType>(
        _ key: NSAttributedString.Key,
        value: AttributeType?
    ) where AttributeType: OptionSet {
        if let value = value {
            addAttribute(key, value: value.rawValue)
        } else {
            removeAttribute(key)
        }
    }
}

fileprivate extension NSAttributedString {
    var entireRange: NSRange {
        NSRange(location: 0, length: self.length)
    }
    func stringByAddingAttribute(_ key: NSAttributedString.Key, value: Any) -> NSAttributedString {
        let changedString = NSMutableAttributedString(attributedString: self)
        changedString.addAttribute(key, value: value, range: self.entireRange)
        return changedString
    }
    func stringByRemovingAttribute(_ key: NSAttributedString.Key) -> NSAttributedString {
        let changedString = NSMutableAttributedString(attributedString: self)
        changedString.removeAttribute(key, range: self.entireRange)
        return changedString
    }
}
extension NSParagraphStyle {
    var mutable: NSMutableParagraphStyle {
        let mutable = NSMutableParagraphStyle()
        mutable.setParagraphStyle(self)
        return mutable
    }
}
extension NSMutableParagraphStyle {
    func withProperty<ValueType>(
        _ value: ValueType,
        for keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, ValueType>
    ) -> NSMutableParagraphStyle {
        self[keyPath: keyPath] = value
        return self
    }
}
