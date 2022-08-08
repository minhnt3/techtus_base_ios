//
//  BaseTableViewSectionBinding.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 20/06/2022.
//

import UIKit

@objc protocol BaseTableViewSectionBindingDelegate: BaseTableViewBindingDelegate {
    @objc optional func handleHeaderAction(view: BaseView, cellViewModel: BaseCellViewModel, at section: Int)
    @objc optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

class BaseTableViewSectionBinding: NSObject, UITableViewDataSource, UITableViewDelegate {
    var showSectionIndexTitles = false
    private var selectedCell: Observable<BaseCellViewModel>?
    private var data: [BaseSection] = []
    private var refreshAction: VoidAction?
    weak var delegate: BaseTableViewSectionBindingDelegate?
    private var theme: Theme?
    required init(tableView: UITableView, data: Observable<[BaseSection]>, theme: Theme, selectedCell: Observable<BaseCellViewModel>?, refreshAction: VoidAction?) {
        super.init()
        data.observe(on: self) {[weak self] sections in
            tableView.pullLoader.stopPullToRefresh()
            tableView.pullLoader.stopLoadingMore()
            if let sections = sections {
                self?.data = sections
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
        self.selectedCell = selectedCell
        if let refreshAction = refreshAction {
            self.refreshAction = refreshAction
            tableView.pullLoader.addPullToRefresh {[weak self] in
                self?.refreshAction?()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.theme = theme
    }
    class func bind(_ tableView: UITableView, data: Observable<[BaseSection]>, theme: Theme, selectedCell: Observable<BaseCellViewModel>?, refreshAction: VoidAction?) -> Self {
        return self.init(tableView: tableView, data: data, theme: theme, selectedCell: selectedCell, refreshAction: refreshAction)
    }
    class func bind(_ tableView: UITableView, data: Observable<[BaseSection]>, theme: Theme, selectedCell: Observable<BaseCellViewModel>?) -> Self {
        return self.init(tableView: tableView, data: data, theme: theme, selectedCell: selectedCell, refreshAction: nil)
    }
    class func bind(_ tableView: UITableView, data: Observable<[BaseSection]>, theme: Theme) -> Self {
        return self.init(tableView: tableView, data: data, theme: theme, selectedCell: nil, refreshAction: nil)
    }
    func setupStyle(theme: Theme) {
        self.theme = theme
    }
    // MARK: TableView Datasource - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = data[section]
        return cells.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = self.data[indexPath.section]
        let cellViewModel = sectionData.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.nibName, for: indexPath) as! BaseTableViewCell
        delegate?.handleAction?(cell, cellViewModel: cellViewModel, at: indexPath)
        cell.bind(cellViewModel)
        cell.setupStyle(theme: theme ?? .light)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionData = self.data[indexPath.section]
        let cellViewModel = sectionData.data[indexPath.row]
        return cellViewModel.height ?? UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.data[section].header?.height ?? 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.data[section].footer?.height ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.data[section].header else {return nil}
        let headerView = Bundle.main.loadNibNamed(header.nibName, owner: nil, options: nil)?.first as! BaseView
        delegate?.handleHeaderAction?(view: headerView, cellViewModel: header, at: section)
        headerView.bind(header)
        headerView.setupStyle(theme: theme ?? .light)
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self.data[section].footer else {return nil}
        let footerView = Bundle.main.loadNibNamed(footer.nibName, owner: nil, options: nil)?.first as? BaseView
        footerView?.bind(footer)
        footerView?.setupStyle(theme: theme ?? .light)
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell?.value = self.data[indexPath.section].data[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if showSectionIndexTitles {
            return data.map { section -> String in
                section.header?.title ?? ""
            }
        }
        return nil
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    // MARK: ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
}
