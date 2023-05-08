//
//  GiftItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import Foundation
import UIKit

struct GiftItemViewModel {
    var voucher: Voucher

    func image() -> UIImage? {
        return voucher.serviceTypes.count > 1 ? UIImage(named: "ic_all_history") : UIImage(named: "ic_" + (voucher.serviceTypes.first?.rawValue.lowercased() ?? "others") + "_history")
    }

    func description() -> String {
        return voucher.description
    }

    func expirationDate() -> String {
        return "Expired in: " + voucher.expirationTime.formatDate()
    }

    func isReadyToUse() -> Bool {
        return self.voucher.openTime <= Date()
    }
}
