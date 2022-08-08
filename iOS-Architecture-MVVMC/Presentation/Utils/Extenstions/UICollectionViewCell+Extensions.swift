//
//  UICollectionViewCell+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

enum CollectionViewKind: String {
    case header
    case footer

    var value: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        default:
            return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionViewCell {
    func dropShadow(masksToBounds: Bool? = false,
                    shadowColor: UIColor? = UIColor.black,
                    shadowOpacity: Float? = 0.5,
                    shadowOffset: CGSize? = CGSize(width: 0.0, height: 2.0),
                    shadowRadius: CGFloat? = 4.0,
                    cornerRadius: CGFloat? = 5.0) {
        layer.masksToBounds = masksToBounds!
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity!
        layer.shadowOffset = shadowOffset!
        layer.shadowRadius = shadowRadius!
        layer.cornerRadius = cornerRadius!
        clipsToBounds = true
    }
}
