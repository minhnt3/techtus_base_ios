//
//  CGSize+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import UIKit

extension CGSize {
    func fixedSize(with reference: CGSize) -> CGSize {
        if reference.width > reference.height {
            return fixedLandscapeSize()
        } else {
            return fixedPortraitSize()
        }
    }

    func fixedLandscapeSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width < height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }

    func fixedPortraitSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width > height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }

    func fixedSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width < height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }

    var isDiffZero: Bool {
        return self != .zero
    }
}
