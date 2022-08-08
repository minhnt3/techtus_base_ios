//
//  BaseCollectionViewSectionBinding.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 20/06/2022.
//

import UIKit

protocol BaseCollectionViewSectionBindingDelegate: BaseCollectionViewBindingDelegate {
    func handleHeaderAction(view: ReactiveViewProtocol, cellViewModel: BaseCellViewModel, at section: Int)
}

class BaseCollectionViewSectionBinding: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private var data: [BaseSection] = []
    private var selectedCell: Observable<BaseCellViewModel>?
    private var refreshAction: VoidAction?
    weak var delegate: BaseCollectionViewSectionBindingDelegate?
    private let collectionView: UICollectionView
    private var theme: Theme?
    required init(_ collectionView: UICollectionView, data: Observable<[BaseSection]>, theme: Theme, selectedCell: Observable<BaseCellViewModel>?, refreshAction: VoidAction?) {
        self.collectionView = collectionView
        self.collectionView.register(BaseReusableView.self, forSupplementaryViewOfKind:
                                        UICollectionView.elementKindSectionHeader, withReuseIdentifier: BaseReusableViewModel().nibName)
        super.init()
        data.observe(on: self) {[weak self] sections in
            collectionView.pullLoader.stopPullToRefresh()
            collectionView.pullLoader.stopLoadingMore()
            if let sections = sections {
                self?.data = sections
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
        self.selectedCell = selectedCell
        if let refreshAction = refreshAction {
            self.refreshAction = refreshAction
            collectionView.pullLoader.addPullToRefresh {[weak self] in
                self?.refreshAction?()
            }
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.theme = theme
    }
    class func bind(_ collectionView: UICollectionView, data: Observable<[BaseSection]>, theme: Theme, selectedCell: Observable<BaseCellViewModel>?) -> Self {
        return self.init(collectionView, data: data, theme: theme, selectedCell: selectedCell, refreshAction: nil)
    }
    class func bind(_ collectionView: UICollectionView, data: Observable<[BaseSection]>, theme: Theme, selectedCell: Observable<BaseCellViewModel>?, refreshAction: VoidAction?) -> Self {
        return self.init(collectionView, data: data, theme: theme, selectedCell: selectedCell, refreshAction: refreshAction)
    }
    func setupStyle(theme: Theme) {
        self.theme = theme
    }
    // MARK: CollectionView Datasource - Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = data[indexPath.section].data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.nibName, for: indexPath) as! BaseCollectionViewCell
        delegate?.handleAction(cell, cellViewModel: cellViewModel, at: indexPath)
        cell.bind(cellViewModel)
        cell.setupStyle(theme: theme ?? .light)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellViewModel = data[indexPath.section].data[indexPath.row]
        return cellViewModel.size ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return data[section].header?.size ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return data[section].footer?.size ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = data[indexPath.section].header ?? BaseReusableViewModel()
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.nibName, for: indexPath) as! BaseReusableView
            delegate?.handleHeaderAction(view: headerView, cellViewModel: header, at: indexPath.section)
            headerView.bind(header)
            headerView.setupStyle(theme: theme ?? .light)
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = data[indexPath.section].footer ?? BaseReusableViewModel()
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.nibName, for: indexPath) as! BaseReusableView
            footerView.bind(footer)
            footerView.setupStyle(theme: theme ?? .light)
            return footerView
        }
        fatalError()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = data[indexPath.section].data[indexPath.row]
        self.selectedCell?.value = cellViewModel
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
