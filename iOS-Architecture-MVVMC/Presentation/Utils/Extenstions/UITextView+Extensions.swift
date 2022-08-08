//
//  UITextView+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

final class LinkTextViewDelegateRepresents: NSObject {
    typealias Action = (_ textView: UITextView, _ url: URL, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool
    var action: Action
    init(action: @escaping Action) {
        self.action = action
    }
}

extension LinkTextViewDelegateRepresents: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return action(textView, URL, characterRange, interaction)
    }
}

extension UITextView {
    func addLink(pattern: String, urlString: String = "", color: UIColor) {
        _ = _addLink(pattern: pattern, urlString: urlString, color: color)
    }
    func addLink(pattern: String, urlString: String = "", color: UIColor, action: @escaping LinkTextViewDelegateRepresents.Action) -> LinkTextViewDelegateRepresents? {
        return _addLink(pattern: pattern, urlString: urlString, color: color, action: action)
    }
    private func _addLink(pattern: String, urlString: String = "", color: UIColor, action: LinkTextViewDelegateRepresents.Action? = nil) -> LinkTextViewDelegateRepresents? {
        // Configure
        isEditable = false
        isSelectable = true
        isUserInteractionEnabled = true
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        // Add Color
        linkTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        // String
        let strings = [attributedText?.string, text].compactMap { $0 }
        guard let string = strings.first else { return nil }
        // Ranges
        let nsRanges = string.nsRanges(of: pattern, options: [.literal])
        if nsRanges.count == 0 { return nil }
        // Add Link
        let attributedString = attributedText != nil ? NSMutableAttributedString(attributedString: attributedText!) : NSMutableAttributedString(string: string)
        for nsRange in nsRanges {
            attributedString.addAttributes([.link: urlString], range: nsRange)
        }
        // Set Text
        attributedText = attributedString
        // Return
        if let action = action {
            return LinkTextViewDelegateRepresents(action: action)
        } else {
            return nil
        }
    }
}
