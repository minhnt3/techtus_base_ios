//
//  BaseButton.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 25/05/2022.
//

import UIKit

class BaseButton: UIButton {
    public typealias Action = ((_ sender: UIButton) -> Void)
    var onPressed: Action? {
        didSet {
            addTarget(self, action: #selector(_onPressed), for: .touchUpInside)
        }
    }
    @objc private func _onPressed(sender: UIButton) {
        onPressed?(sender)
    }
    @IBInspectable var primaryColor: UIColor?
    @IBInspectable var highlightedColor: UIColor?
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            if isEnabled {
                applyBorder(color: borderColor)
            }
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var disabledBorderColor: UIColor = .clear {
        didSet {
            if !isEnabled {
                applyBorder(color: disabledBorderColor)
            }
        }
    }
    public init() {
        super.init(frame: CGRect.zero)
        imageView?.clipsToBounds = false
        imageView?.contentMode = .center
        adjustsImageWhenHighlighted = false
    }
    convenience init(ofSize size: CGFloat) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: size).isActive=true
        self.widthAnchor.constraint(equalToConstant: size).isActive=true
    }
    convenience init(with image: UIImage? = nil) {
        self.init()
        if let image = image {
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override var isEnabled: Bool {
        didSet {
            isEnabled ? applyBorder(color: borderColor) : applyBorder(color: disabledBorderColor)
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            let highlightedColor = highlightedColor ?? backgroundColor
            let primaryColor = primaryColor ?? backgroundColor
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.backgroundColor = self?.isHighlighted == true ? highlightedColor : primaryColor
            }, completion: { [weak self] _ in
                self?.backgroundColor = self?.isHighlighted == true ? highlightedColor : primaryColor
            })
        }
    }
}
