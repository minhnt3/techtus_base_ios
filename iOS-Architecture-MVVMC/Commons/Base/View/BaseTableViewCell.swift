//
//  BaseTableViewCell.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 17/06/2022.
//

import UIKit
class BaseTableViewCell: UITableViewCell, ReactiveViewProtocol {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bind(_ viewModel: BaseCellViewModel?) { }

    func setupStyle(theme: Theme) {}

}
