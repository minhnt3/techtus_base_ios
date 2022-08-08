//
//  UITextfield+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 14/06/2022.
//

import UIKit

private struct AssociationKey {
    fileprivate static var contentInsets: String = "uitextfield.contentInsets"
}

extension UITextField {
    var contentInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &AssociationKey.contentInsets) as? NSValue {
                return value.uiEdgeInsetsValue
            }
            return UIEdgeInsets.zero
        }
        set { objc_setAssociatedObject(self, &AssociationKey.contentInsets, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    public func setBottomBorder(_ color: UIColor, _ borderHeight: CGFloat = 1.0) {
        borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: borderHeight)
        bottomLine.backgroundColor = color.cgColor
        layer.addSublayer(bottomLine)
    }
    func setPlaceholderColor(color: UIColor) {
        let placeholder = placeholder ?? ""
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension UITextField {
    class func connectAllTxtFieldFields(txtfields: [UITextField]) {
        guard let last = txtfields.last else {
            return
        }
        for index in 0 ..< txtfields.count - 1 {
            txtfields[index].returnKeyType = .next
            txtfields[index].addTarget(txtfields[index + 1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}
