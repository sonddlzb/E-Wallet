//
//  ServiceViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import Foundation

struct ServiceViewModel {
    var listServices: [ServiceType]

    func service(at index: Int) -> ServiceType {
        return listServices[index]
    }

    func numberOfServices() -> Int {
        return listServices.count
    }

    static func makeFull() -> ServiceViewModel {
        return ServiceViewModel(listServices: ServiceType.allCases)
    }
}
