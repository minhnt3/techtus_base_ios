//
//  BaseTextView.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 17/06/2022.
//

import UIKit

protocol BaseTextViewDelegate: AnyObject {
    func textDidChange(text: String?, textView: UITextView)
    func textShouldBeginEditing(text: String?, textView: UITextView)
    func textShouldEndEditing(text: String?, textView: UITextView)
    func textDidBeginEditing(text: String?, textView: UITextView)
    func textDidEndEditing(text: String?, textView: UITextView)
}

class BaseTextView: UITextView {
    @IBInspectable var borderColor: UIColor? {
        get { return self.borderColor }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    weak var textViewDelegate: BaseTextViewDelegate?
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    @IBInspectable var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension BaseTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
        textViewDelegate?.textDidChange(text: text, textView: textView)
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textViewDelegate?.textShouldBeginEditing(text: text, textView: textView)
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textViewDelegate?.textShouldEndEditing(text: text, textView: textView)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewDelegate?.textDidBeginEditing(text: text, textView: textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewDelegate?.textDidEndEditing(text: text, textView: textView)
    }
}
