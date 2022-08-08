//
//  UIImage+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 14/06/2022.
//

import UIKit

extension UIImage {
    // Load bundle image with file name
    public class func load(fileName: String, extensionType: String = "png") -> UIImage? {
        func pathForResource(_ fileName: String, ofType: String) -> String? {
            return Bundle.main.path(forResource: fileName, ofType: ofType)
        }
        if UIScreen.main.bounds.width > 375.0 {
            if let filePath = pathForResource("\(fileName)@3x", ofType: extensionType) {
                return UIImage(contentsOfFile: filePath)
            }
        }
        if let filePath = pathForResource("\(fileName)@2x", ofType: extensionType) {
            return UIImage(contentsOfFile: filePath)
        }
        if let filePath = pathForResource(fileName, ofType: extensionType) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
}

extension UIImage {
    // Represent current image to render mode original.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    func orientation(to orientation: UIImage.Orientation) -> UIImage {
        if imageOrientation == orientation {
            return self
        }
        if let CGImage = cgImage {
            return UIImage(cgImage: CGImage, scale: UIScreen.main.scale, orientation: orientation)
        }
        debugPrint("Cannot complete action.")
        return self
    }
    var bytes: Data? {
        // Establish color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Establish context
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else { return nil }
        // Draw source into context bytes
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        guard let CGImage = cgImage else {
            return nil
        }
        context.draw(CGImage, in: rect)
        // Create NSData from bytes
        if let data = context.data {
            return Data(bytes: UnsafeMutableRawPointer(data), count: (width * height * 4))
        } else {
            return nil
        }
    }
}

// MARK: - Draw
public extension UIImage {
     class func make(
        color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1),
        roundingCorners: UIRectCorner = .allCorners,
        radius: CGFloat = 0,
        strokeColor: UIColor = UIColor.clear,
        strokeLineWidth: CGFloat = 0) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { fatalError() }
        context.setFillColor(color.cgColor)
        context.setLineWidth(strokeLineWidth)
        context.setStrokeColor(strokeColor.cgColor)
        let roundedRect = CGRect(
            x: strokeLineWidth,
            y: strokeLineWidth,
            width: rect.width - strokeLineWidth * 2,
            height: rect.height - strokeLineWidth * 2)
        let path = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        context.addPath(path.cgPath)
        context.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
     func remake(
        roundingCorners corners: UIRectCorner = .allCorners,
        radius: CGFloat = 0,
        strokeColor: UIColor? = nil,
        strokeLineWidth: CGFloat = 0,
        stockLineJoin: CGLineJoin = .miter) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        let roundedRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        let sideLength = min(roundedRect.size.width, roundedRect.size.height)
        if strokeLineWidth < sideLength * 0.5 {
            let roundedpath = UIBezierPath(
                roundedRect: roundedRect.insetBy(dx: strokeLineWidth, dy: strokeLineWidth),
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: strokeLineWidth)
            )
            roundedpath.close()
            context.saveGState()
            context.addPath(roundedpath.cgPath)
            context.clip()
            context.draw(cgImage!, in: roundedRect)
            context.restoreGState()
        }

        if nil != strokeColor && strokeLineWidth > 0 {
            let strokeInset = (floor(strokeLineWidth * scale) + 0.5) / scale
            let strokeRect = roundedRect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > scale / 2.0 ? radius - scale / 2.0 : 0.0
            let strokePath = UIBezierPath(
                roundedRect: strokeRect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: strokeRadius, height: strokeLineWidth)
            )
            strokePath.close()

            context.saveGState()
            context.setStrokeColor(strokeColor!.cgColor)
            context.setLineWidth(strokeLineWidth)
            context.setLineJoin(stockLineJoin)
            context.addPath(strokePath.cgPath)
            context.strokePath()
            context.restoreGState()
        }
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
     var circle: UIImage {
        var newImage: UIImage = self
        let sideLength = min(size.width, size.height)
        if size.width != size.height {
            let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            let newRect = CGRect(x: center.x - sideLength * 0.5, y: center.y - sideLength * 0.5, width: sideLength, height: sideLength)
            if let image = extracting(in: newRect) {
                newImage = image
            }
        }
        return newImage.remake(radius: sideLength * 0.5)
    }
     func remake(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        draw(in: rect, blendMode: .normal, alpha: alpha)
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
     func rendering(color: UIColor, alpha: CGFloat = 1.0) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(rect)
        draw(in: rect, blendMode: .overlay, alpha: alpha)
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
    // Extract image
    func extracting(in subRect: CGRect) -> UIImage? {
        if let imageRef = cgImage!.cropping(to: subRect) {
            return UIImage(cgImage: imageRef)
        }
        return nil
    }
}
