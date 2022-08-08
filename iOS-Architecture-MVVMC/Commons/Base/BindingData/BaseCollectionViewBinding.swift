//
//  BaseCollectionViewBinding.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 20/06/2022.
//

import UIKit

protocol BaseCollectionViewBindingDelegate: AnyObject {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func collectionViewWillBeginDecelerating(_ scrollView: UIScrollView)
    func handleAction(_ cell: BaseCollectionViewCell, cellViewModel: BaseCellViewModel, at indexPath: IndexPath)
}
class BaseCollectionViewBinding<T: BaseCellViewModel>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private var data: [T] = []
    private var selectedCell: Observable<T>?
    private var loadMoreAction: VoidAction?
    private var refreshAction: VoidAction?
    private let collectionView: UICollectionView
    weak var delegate: BaseCollectionViewBindingDelegate?
    private var theme: Theme?
    required init(_ collectionView: UICollectionView, data: Observable<[T]>, theme: Theme, selectedCell: Observable<T>? = nil, loadMoreAction: VoidAction? = nil, refreshAction: VoidAction? = nil) {
        self.collectionView = collectionView
        super.init()
        data.observe(on: self) { [weak self] data in
            collectionView.pullLoader.stopPullToRefresh()
            collectionView.pullLoader.stopLoadingMore()
            if let data = data {
                self?.data = data
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
        self.selectedCell = selectedCell
        if let loadMoreAction = loadMoreAction {
            self.loadMoreAction = loadMoreAction
            collectionView.pullLoader.addInfiniteScrolling {[weak self] in
                self?.loadMoreAction?()
            }
        }
        if let refreshAction = refreshAction {
            self.refreshAction = refreshAction
            collectionView.pullLoader.addPullToRefresh {[weak self] in
                self?.refreshAction?()
            }
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.theme = theme
    }
    func setupStyle(theme: Theme) {
        self.theme = theme
    }
    // MARK: CollectionView Datasource - Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.nibName, for: indexPath) as! BaseCollectionViewCell
        delegate?.handleAction(cell, cellViewModel: cellViewModel, at: indexPath)
        cell.bind(cellViewModel)
        cell.setupStyle(theme: theme ?? .light)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellViewModel = data[indexPath.row]
        return cellViewModel.size ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = data[indexPath.row]
        selectedCell?.value = cellViewModel
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating(scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.collectionViewWillBeginDecelerating(scrollView)
    }
}
