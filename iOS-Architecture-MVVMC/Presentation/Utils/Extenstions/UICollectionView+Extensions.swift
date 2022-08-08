//
//  UICollectionView+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(aClass: T.Type) {
        let className = String(describing: aClass)
        let nibFile = UINib.nib(withName: className)
        register(nibFile, forCellWithReuseIdentifier: className)
    }

    func registerCell<T: UICollectionViewCell>(aClass: T.Type, kind: CollectionViewKind) {
        let className = String(describing: aClass)
        let nibFile = UINib.nib(withName: className)
        register(nibFile, forSupplementaryViewOfKind: kind.value, withReuseIdentifier: className)
    }

    func register<T: UICollectionReusableView>(footer aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionFooter
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func register<T: UICollectionReusableView>(header aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionHeader
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func dequeueCell<T: UICollectionViewCell>(aClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }

    func dequeueCell<T: UICollectionReusableView>(aClass: T.Type, kind: CollectionViewKind, indexPath: IndexPath) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind.value,
                                                          withReuseIdentifier: className,
                                                          for: indexPath) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }
}
