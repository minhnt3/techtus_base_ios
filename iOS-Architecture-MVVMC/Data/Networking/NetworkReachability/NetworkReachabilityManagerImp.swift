//
//  NetworkReachabilityManagerImp.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 12/07/2022.
//

import Foundation
import Alamofire

class NetworkReachabilityManagerImp: NetworkReachabilityManager {

    var isReachable: Bool {
        Alamofire.NetworkReachabilityManager.default?.isReachable ?? false
    }
}
