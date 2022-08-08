//
//  UITableView+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

extension UITableView {
    func scroll(scrollTo: ScrollTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            switch scrollTo {
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }

    var isEmpty: Bool {
        var count = 0
        for section in 0 ..< numberOfSections {
            count += numberOfRows(inSection: section)
        }
        return count == 0
    }

    enum ScrollTo {
        case top, bottom
    }

    func registerCell<T: UITableViewCell>(aClass: T.Type) {
        let className = String(describing: aClass)
        let nibFile = UINib.nib(withName: className)
        register(nibFile, forCellReuseIdentifier: className)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let className = String(describing: aClass)
        let nibFile = UINib.nib(withName: className)
        register(nibFile, forHeaderFooterViewReuseIdentifier: className)
    }

    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let className = String(describing: aClass)
        register(aClass, forHeaderFooterViewReuseIdentifier: className)
    }

    func dequeueCell<T: UITableViewCell>(aClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }

    func dequeueCell<T: UITableViewCell>(aClass: T.Type) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: className) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(aClass: T.Type) -> T {
        let className = String(describing: aClass)
        guard let headerView = dequeueReusableHeaderFooterView(withIdentifier: className) as? T else {
            fatalError("\(className) isn't register")
        }
        return headerView
    }
}
