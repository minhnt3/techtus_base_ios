//
//  UIView+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

enum AIEdge: Int {
    case top, left, bottom, right, topLeft, topRight, bottomLeft, bottomRight, all, none
}
extension UIView {
    class func instanceFromNib() -> Self {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}
extension UIView {
    var width: CGFloat {  return self.frame.size.width }
    var height: CGFloat { return self.frame.size.height}
    var xPos: CGFloat { return self.frame.origin.x }
    var yPos: CGFloat { return self.frame.origin.y }
    // MARK: Rotate
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        self.transform = self.transform.rotated(by: radians)
    }
    // MARK: Border
    func applyBorder(color: UIColor, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    // MARK: Circle
    func applyCircle() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    // MARK: Radius
    func applyCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    // MARK: Shadow
    func applyShadowWithColor(color: UIColor, opacity: Float = 0.5, radius: CGFloat = 1) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
    func applyShadowWithColor(color: UIColor, opacity: Float, radius: CGFloat, edge: AIEdge, shadowSpace: CGFloat) {
        var sizeOffset: CGSize = CGSize.zero
        switch edge {
        case .top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)
        case .topLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .topRight:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .bottomLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .bottomRight:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)
        case .all:
            sizeOffset = CGSize(width: 0, height: 0)
        case .none:
            sizeOffset = CGSize.zero
        }
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
    func addBorderWithColor(color: UIColor, edge: AIEdge, thicknessOfBorder: CGFloat) {
        DispatchQueue.main.async {
            var rect: CGRect = CGRect.zero
            switch edge {
            case .top:
                rect = CGRect(x: 0, y: 0, width: self.width, height: thicknessOfBorder)
            case .left:
                rect = CGRect(x: 0, y: 0, width: thicknessOfBorder, height: self.width)
            case .bottom:
                rect = CGRect(x: 0, y: self.height - thicknessOfBorder, width: self.width, height: thicknessOfBorder)
            case .right:
                rect = CGRect(x: self.width - thicknessOfBorder, y: 0, width: thicknessOfBorder, height: self.height)
            default:
                break
            }
            let layerBorder = CALayer()
            layerBorder.frame = rect
            layerBorder.backgroundColor = color.cgColor
            self.layer.addSublayer(layerBorder)
        }
    }
}
