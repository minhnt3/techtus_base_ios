//
//  LoadingView.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 26/05/2022.
//

import UIKit

class LoadingView: BaseView {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func handleLoading(_ isLoading: Bool) {
        if isLoading {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }

    func showLoading(with message: String) {
        loadingLabel.text = message
        indicator.startAnimating()
    }
}
