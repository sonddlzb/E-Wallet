//
//  BillDetailsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import Foundation

struct BillDetailsViewModel {
    var bill: Bill

    func supplier() -> String {
        return bill.supplier
    }

    func customerId() -> String {
        return bill.customerId
    }

    func customerName() -> String {
        return bill.customerName
    }

    func address() -> String {
        return bill.address
    }

    func billType() -> String {
        return bill.type.rawValue.capitalized
    }

    func period() -> String {
        return self.billType() + "'s fee " + bill.period
    }

    func amount() -> String {
        return "$" + String(bill.amount)
    }
}
