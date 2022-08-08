//
//  BaseToast.swift
//

import UIKit

extension UIViewController {
    func showToast(_ title: String?, position: ToastPosition = .bottom, style: ToastStyle = .init()) {
        let wrapperView = UIView()
        var titleLabel: UILabel?
        wrapperView.backgroundColor = style.backgroundColor
        wrapperView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        wrapperView.layer.cornerRadius = style.cornerRadius
        if style.displayShadow {
            wrapperView.layer.shadowColor = UIColor.black.cgColor
            wrapperView.layer.shadowOpacity = style.shadowOpacity
            wrapperView.layer.shadowRadius = style.shadowRadius
            wrapperView.layer.shadowOffset = style.shadowOffset
        }
        if let title = title {
            titleLabel = createTitleLabel(title: title, style: style)
            let maxTitleSize = CGSize(width: (self.view.bounds.size.width * style.maxWidthPercentage), height: self.view.bounds.size.height * style.maxHeightPercentage)
            let titleSize = titleLabel?.sizeThatFits(maxTitleSize)
            if let titleSize = titleSize {
                titleLabel?.frame = CGRect(x: 0.0, y: 0.0, width: titleSize.width, height: titleSize.height)
            }
        }
        var titleRect = CGRect.zero
        if let titleLabel = titleLabel {
            titleRect.origin.x = style.horizontalPadding
            titleRect.origin.y = style.verticalPadding
            titleRect.size.width = titleLabel.bounds.size.width
            titleRect.size.height = titleLabel.bounds.size.height
        }
        let longerWidth = titleRect.size.width
        let longerX = titleRect.origin.x
        let wrapperWidth = longerX + longerWidth + style.horizontalPadding
        let wrapperHeight = titleRect.size.height + style.verticalPadding * 2.0
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        if let titleLabel = titleLabel {
            titleRect.size.width = longerWidth
            titleLabel.frame = titleRect
            wrapperView.addSubview(titleLabel)
        }
        wrapperView.center = position.centerPoint(forToast: wrapperView, style: style, inSuperview: self.view)
        self.view.addSubview(wrapperView)
        UIView.animate(withDuration: style.fadeDuration, delay: 0.1, options: .curveEaseOut, animations: {
            wrapperView.alpha = 0.0
        }, completion: { _ in
            wrapperView.removeFromSuperview()
        })
    }
    private func createTitleLabel(title: String, style: ToastStyle) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = style.titleNumberOfLines
        titleLabel.font = style.titleFont
        titleLabel.textAlignment = style.titleAlignment
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = style.titleColor
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = title
        return titleLabel
    }
}
