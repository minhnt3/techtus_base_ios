//
//  BaseReusableViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 20/06/2022.
//

import UIKit

class BaseReusableViewModel: BaseCellViewModel {
     override init() {
          super.init()
          self.nibName = "BaseReusableView"
     }
}
