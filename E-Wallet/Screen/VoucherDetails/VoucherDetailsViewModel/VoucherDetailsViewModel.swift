//
//  VoucherDetailsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import Foundation
import UIKit

struct VoucherDetailsViewModel {
    var voucher: Voucher

    func image() -> UIImage? {
        return voucher.serviceTypes.count > 1 ? UIImage(named: "ic_all_history") : UIImage(named: "ic_" + (voucher.serviceTypes.first?.rawValue.lowercased() ?? "others") + "_history")
    }

    func description() -> String {
        return voucher.description
    }

    func effectedTime() -> String {
        return voucher.openTime.formatDate()
    }

    func expiredTime() -> String {
        return voucher.expirationTime.formatDate()
    }

    func serviceTypeContent() -> String {
        var serviceContent = ""
        if voucher.serviceTypes.count > 1 {
            serviceContent += "- This voucher is available when you pay for"
            for serviceType in voucher.serviceTypes {
                serviceContent += serviceType != voucher.serviceTypes.first ? ", \(serviceType.rawValue.capitalized)" : " \(serviceType.rawValue.capitalized)"
            }

            return serviceContent + " bills."
        } else {
            if let serviceType = voucher.serviceTypes.first {
                switch serviceType {
                case .electricity, .internet, .prepaidTopUp, .water, .televison:
                    return "- This voucher is available when you pay for \(serviceType.rawValue.capitalized) bill."
                case .cinema: return "- This voucher is available for booking cinema ticket."
                case .tuition: return "- This voucher is available for paying your tuition."
                default: return ""
                }
            }
        }

        return serviceContent
    }

    func minValueContent() -> String {
        if voucher.minValue == 0 {
            return "- If your bill's total value is smaller than discount amount, you can purchase it for free."
        } else {
            return "- Your bill's total value must be greater than $\(voucher.minValue)."
        }
    }
}
