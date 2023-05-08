//
//  EnterBillViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import Foundation
import UIKit

struct EnterBillViewModel {
    var serviceType: ServiceType

    func name() -> String {
        return serviceType.rawValue.uppercased()
    }

    func image() -> UIImage? {
        return serviceType.image()
    }
}
