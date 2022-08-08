//
//  AnimalsViewController.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import UIKit

class AnimalsViewController: BaseViewController<AnimalViewModel> {
    @IBOutlet weak var animalsTableView: UITableView!

    var animalsTableViewBinding: BaseTableViewBinding<AnimalCellViewModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        animalsTableView.registerCell(aClass: AnimalCell.self)
        viewModel.fetchAnimals()
    }

    override func bindViewModel() {
        super.bindViewModel()
        animalsTableViewBinding = BaseTableViewBinding(tableView: animalsTableView,
                                                       data: viewModel.animalsObservable,
                                                       theme: theme,
                                                       selectedCell: nil,
                                                       loadMoreAction: nil,
                                                       refreshAction: nil)
    }

    override func setupLanguagueText() {
        super.setupLanguagueText()
        title = Strings.AnimalsScreen.title
    }
}
