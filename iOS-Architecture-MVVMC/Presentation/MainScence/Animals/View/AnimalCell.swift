//
//  AnimalCell.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import UIKit

class AnimalCell: BaseTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        weightLabel.text = nil
    }

    override func bind(_ viewModel: BaseCellViewModel?) {
        guard let viewModel = viewModel as? AnimalCellViewModel else { return }
        nameLabel.text = viewModel.name
        weightLabel.text = viewModel.weight.description
    }
}
