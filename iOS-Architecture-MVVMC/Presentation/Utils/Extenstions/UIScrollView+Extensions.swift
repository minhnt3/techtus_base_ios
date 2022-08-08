//
//  UIScrollView+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

extension UIScrollView {
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            UIView.animate(withDuration: 0.4, animations: {
                // Get the Y position of your child view
                let childStartPoint = origin.convert(view.frame.origin, to: self)
                // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
                self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
            })
        }
    }
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}

extension UIScrollView {
    var insetTop: CGFloat {
        get { return contentInset.top }
        set {
            var inset = contentInset
            inset.top = newValue
            contentInset = inset
        }
    }
    var insetLeft: CGFloat {
        get { return contentInset.left }
        set {
            var inset = contentInset
            inset.left = newValue
            contentInset = inset
        }
    }
    var insetBottom: CGFloat {
        get { return contentInset.bottom }
        set {
            var inset = contentInset
            inset.bottom = newValue
            contentInset = inset
        }
    }
    var insetRight: CGFloat {
        get { return contentInset.right }
        set {
            var inset = contentInset
            inset.right = newValue
            contentInset = inset
        }
    }
    var scrollIndicatorInsetTop: CGFloat {
        get { return  scrollIndicatorInsets.top }
        set {
            var inset = scrollIndicatorInsets
            inset.top = newValue
            scrollIndicatorInsets = inset
        }
    }
    var scrollIndicatorInsetLeft: CGFloat {
        get { return scrollIndicatorInsets.left }
        set {
            var inset = scrollIndicatorInsets
            inset.left = newValue
            scrollIndicatorInsets = inset
        }
    }
    var scrollIndicatorInsetBottom: CGFloat {
        get { return scrollIndicatorInsets.bottom }
        set {
            var inset = scrollIndicatorInsets
            inset.bottom = newValue
            scrollIndicatorInsets = inset
        }
    }
    var scrollIndicatorInsetRight: CGFloat {
        get { return scrollIndicatorInsets.right }
        set {
            var inset = scrollIndicatorInsets
            inset.right = newValue
            scrollIndicatorInsets = inset
        }
    }
    var contentOffsetX: CGFloat {
        get { return contentOffset.x }
        set {
            var offset = contentOffset
            offset.x = newValue
            contentOffset = offset
        }
    }
    var contentOffsetY: CGFloat {
        get { return contentOffset.y }
        set {
            var offset = contentOffset
            offset.y = newValue
            contentOffset = offset
        }
    }
    var contentSizeWidth: CGFloat {
        get { return contentSize.width }
        set {
            var size = contentSize
            size.width = newValue
            contentSize = size
        }
    }
    var contentSizeHeight: CGFloat {
        get { return contentSize.height }
        set {
            var size = contentSize
            size.height = newValue
            contentSize = size
        }
    }
}
