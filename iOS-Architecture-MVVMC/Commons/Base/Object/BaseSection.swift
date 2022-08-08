//
//  BaseSection.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 20/06/2022.
//

import Foundation

final class BaseSection: Equatable {
    static func == (lhs: BaseSection, rhs: BaseSection) -> Bool {
        return lhs.header == rhs.header && lhs.data == rhs.data && lhs.footer == rhs.footer
    }
    var header: BaseCellViewModel?
    var footer: BaseCellViewModel?
    var data: [BaseCellViewModel]
    required init(data: [BaseCellViewModel], header: BaseCellViewModel?, footer: BaseCellViewModel?) {
        self.data = data
        self.header = header
        self.footer = footer
    }
    class func section(withData cellViewModels: [BaseCellViewModel]) -> Self {
        return self.init(data: cellViewModels, header: nil, footer: nil)
    }
    class func section(withData data: [BaseCellViewModel], header: BaseCellViewModel?) -> Self {
        return self.init(data: data, header: header, footer: nil)
    }
    class func section(withData data: [BaseCellViewModel], header: BaseCellViewModel?, footer: BaseCellViewModel?) -> Self {
        return self.init(data: data, header: header, footer: footer)
    }
}
