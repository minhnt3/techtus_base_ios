//
//  ToastStyle.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 08/06/2022.
//

import UIKit

public struct ToastStyle {
    public init() {}
    /**
     The background color. Default is `.black` at 80% opacity.
     */
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    /**
     The title color. Default is `UIColor.whiteColor()`.
     */
    public var titleColor: UIColor = .white
    /**
     A percentage value from 0.0 to 1.0, representing the maximum width of the toast
     view relative to it's superview. Default is 0.8 (80% of the superview's width).
     */
    public var maxWidthPercentage: CGFloat = 0.8 {
        didSet {
            maxWidthPercentage = max(min(maxWidthPercentage, 1.0), 0.0)
        }
    }
    /**
     A percentage value from 0.0 to 1.0, representing the maximum height of the toast
     view relative to it's superview. Default is 0.8 (80% of the superview's height).
     */
    public var maxHeightPercentage: CGFloat = 0.8 {
        didSet {
            maxHeightPercentage = max(min(maxHeightPercentage, 1.0), 0.0)
        }
    }
    /**
     The spacing from the horizontal edge of the toast view to the content. When an image
     is present, this is also used as the padding between the image and the text.
     Default is 10.0.
     
     */
    public var horizontalPadding: CGFloat = 10.0
    /**
     The spacing from the vertical edge of the toast view to the content. When a title
     is present, this is also used as the padding between the title and the message.
     Default is 10.0. On iOS11+, this value is added added to the `safeAreaInset.top`
     and `safeAreaInsets.bottom`.
     */
    public var verticalPadding: CGFloat = 10.0
    /**
     The corner radius. Default is 10.0.
     */
    public var cornerRadius: CGFloat = 10.0
    /**
     The title font. Default is `.boldSystemFont(16.0)`.
     */
    public var titleFont: UIFont = .boldSystemFont(ofSize: 16.0)
    /**
     The title text alignment. Default is `NSTextAlignment.Left`.
     */
    public var titleAlignment: NSTextAlignment = .left
    /**
     The maximum number of lines for the title. The default is 0 (no limit).
     */
    public var titleNumberOfLines = 0
    /**
     The fade in/out animation duration. Default is 2.
     */
    public var fadeDuration: TimeInterval = 2.0
    /**
     Enable or disable a shadow on the toast view. Default is `false`.
     */
    public var displayShadow = false
    /**
     The shadow color. Default is `.black`.
     */
    public var shadowColor: UIColor = .black
    /**
     A value from 0.0 to 1.0, representing the opacity of the shadow.
     Default is 0.8 (80% opacity).
     */
    public var shadowOpacity: Float = 0.8 {
        didSet {
            shadowOpacity = max(min(shadowOpacity, 1.0), 0.0)
        }
    }
    /**
     The shadow radius. Default is 6.0.
     */
    public var shadowRadius: CGFloat = 6.0
    /**
     The shadow offset. The default is 4 x 4.
     */
    public var shadowOffset = CGSize(width: 4.0, height: 4.0)
}
