//
//  BaseTextField.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 17/06/2022.
//

import UIKit

class BaseTextField: UITextField {
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        }
        set {
            if let value = newValue {
                self.setPlaceholderColor(color: value)
            }
        }
    }
    @IBInspectable var bottomBorderColor: UIColor? {
        get {
            return self.bottomBorderColor
        }
        set {
            if let value = newValue {
                self.setBottomBorder(value)
            }
        }
    }
    // MARK: Add image on the left side
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    @IBInspectable var leftImageColor: UIColor? {
        didSet {
            updateLeftView()
        }
    }
    @IBInspectable var leftImageSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            updateLeftView()
        }
    }
    @IBInspectable var marginLeftImageAndText: CGFloat = 3 {
        didSet {
            updateLeftView()
        }
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    fileprivate func updateLeftView() {
        if let image = leftImage {
            leftViewMode = .always
            let view = UIView(frame: CGRect(x: 0, y: 0, width: leftImageSize.width + marginLeftImageAndText, height: leftImageSize.height))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: leftImageSize.width, height: leftImageSize.height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = leftImageColor
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = .never
            leftView = nil
        }
    }
    // MARK: Add image on the right side
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    @IBInspectable var rightImageSelected: UIImage? {
        didSet {
            updateRightView()
        }
    }
    @IBInspectable var rightImageSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            updateRightView()
        }
    }
    @IBInspectable var marginRightImageAndText: CGFloat = 0 {
        didSet {
            updateRightView()
        }
    }
    var onRightImageTap: VoidAction?
    fileprivate var isRightImageSelected = false
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onImageTap), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
    }()
    fileprivate func updateRightView() {
        if let image = rightImage {
            rightViewMode = .always
            let view = UIView(frame: CGRect(x: 0, y: 0, width: rightImageSize.width + marginRightImageAndText, height: rightImageSize.height))
            rightButton.frame = CGRect(x: marginRightImageAndText, y: 0, width: rightImageSize.width, height: rightImageSize.height)
            rightButton.backgroundImage = image
            view.addSubview(rightButton)
            rightView = view
        } else {
            rightViewMode = .never
            rightView = nil
        }
    }
    fileprivate func updateRightImage() {
        if let rightImageSelected = rightImageSelected {
            if isRightImageSelected {
                rightButton.backgroundImage = rightImageSelected
            } else if let rightImage = rightImage {
                rightButton.backgroundImage = rightImage
            }
        }
    }
    @objc fileprivate func onImageTap() {
        isRightImageSelected = !isRightImageSelected
        updateRightImage()
        onRightImageTap?()
    }
}
