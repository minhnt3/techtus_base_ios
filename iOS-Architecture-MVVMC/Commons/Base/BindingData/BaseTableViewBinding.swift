//
//  TableViewBinding.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 17/06/2022.
//

import UIKit
@objc protocol BaseTableViewBindingDelegate: NSObjectProtocol {
    @objc optional func handleAction(_ cell: BaseTableViewCell, cellViewModel: BaseCellViewModel?, at indexPath: IndexPath)
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
}
class BaseTableViewBinding<T: BaseCellViewModel>: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: BaseTableViewBindingDelegate?
    private var selectedCell: Observable<T>?
    private var data: Observable<[T]> = Observable([])
    private var loadMoreAction: VoidAction?
    private var refreshAction: VoidAction?
    private var theme: Theme?
    required init(tableView: UITableView, data: Observable<[T]>, theme: Theme, selectedCell: Observable<T>?, loadMoreAction: VoidAction?, refreshAction: VoidAction?) {
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        self.theme = theme
        data.observe(on: self) {[weak self] data in
            self?.data.value = data
            tableView.pullLoader.stopPullToRefresh()
            tableView.pullLoader.stopLoadingMore()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        self.selectedCell = selectedCell
        if let loadMoreAction = loadMoreAction {
            self.loadMoreAction = loadMoreAction
            tableView.pullLoader.addInfiniteScrolling {[weak self] in
                self?.loadMoreAction?()
            }
        }
        if let refreshAction = refreshAction {
            self.refreshAction = refreshAction
            tableView.pullLoader.addPullToRefresh {[weak self] in
                self?.refreshAction?()
            }
        }
    }
    // swiftlint:disable:next function_parameter_count
    class func bind(_ tableView: UITableView, data: Observable<[T]>, theme: Theme, selectedCell: Observable<T>?, loadMoreAction: VoidAction?, refreshAction: VoidAction?) -> Self {
         return self.init(tableView: tableView, data: data, theme: theme, selectedCell: selectedCell, loadMoreAction: loadMoreAction, refreshAction: refreshAction)
    }
    class func bind(_ tableView: UITableView, data: Observable<[T]>, theme: Theme, selectedCell: Observable<T>?, loadMoreAction: VoidAction?) -> Self {
         return self.init(tableView: tableView, data: data, theme: theme, selectedCell: selectedCell, loadMoreAction: loadMoreAction, refreshAction: nil)
    }
    class func bind(_ tableView: UITableView, data: Observable<[T]>, theme: Theme, selectedCell: Observable<T>?) -> Self {
         return self.init(tableView: tableView, data: data, theme: theme, selectedCell: selectedCell, loadMoreAction: nil, refreshAction: nil)
    }
    class func bind(_ tableView: UITableView, data: Observable<[T]>, theme: Theme) -> Self {
         return self.init(tableView: tableView, data: data, theme: theme, selectedCell: nil, loadMoreAction: nil, refreshAction: nil)
    }
    func setupStyle(theme: Theme) {
        self.theme = theme
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = data.value?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel?.nibName ?? "", for: indexPath) as! BaseTableViewCell
        delegate?.handleAction?(cell, cellViewModel: cellViewModel, at: indexPath)
        cell.bind(cellViewModel)
        cell.setupStyle(theme: theme ?? .light)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell?.value = data.value?[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = data.value?[indexPath.row]
        return cellViewModel?.height ?? UITableView.automaticDimension
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
}
