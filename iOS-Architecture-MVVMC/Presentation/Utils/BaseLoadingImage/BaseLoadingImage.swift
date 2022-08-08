//
//  BaseLoadingImage.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 31/05/2022.
//

import Foundation
import Kingfisher

typealias LoadingImageProgressBlock = (_ receivedSize: CGFloat, _ totalSize: CGFloat, _ percentLoading: CGFloat) -> Void
extension UIImageView {
    func setImage(url urlImage: String?,
                  placeholder placeholderImage: UIImage? = UIImage.imgPlaceholder,
                  indicatorType type: ImageIndicatorType? = .activity,
                  options imageOptions: LoadingImageOptions? = nil,
                  imageProgressBlock: LoadingImageProgressBlock? = nil) {
        guard let urlImage = urlImage, let url = URL(string: urlImage) else {
            return
        }
        let options = imageOptions?.loadOptions()
        self.setIndicatorType(indicatorType: type)
        self.kf.setImage(with: url,
                         placeholder: placeholderImage,
                         options: options,
                         progressBlock: { receivedSize, totalSize in
            let receivedSize = CGFloat(receivedSize)
            let totalSize = CGFloat(totalSize)
            let percent = (receivedSize / totalSize) * 100.0
            imageProgressBlock?(receivedSize, totalSize, percent)
        })
    }
    private func setIndicatorType(indicatorType type: ImageIndicatorType?) {
        if let type = type {
            switch type {
            case .none:
                self.kf.indicatorType = .none
            case .activity:
                self.kf.indicatorType = .activity
            case .image(let imageData):
                self.kf.indicatorType = .image(imageData: imageData)
            }
        }
    }
}
