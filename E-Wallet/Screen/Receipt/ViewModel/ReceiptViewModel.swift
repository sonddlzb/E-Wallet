//
//  ReceiptViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 21/04/2023.
//

import Foundation

struct ReceiptViewModel {
    var transaction: Transaction

    func title() -> String {
        switch transaction.type {
        case .transfer: return "Transfer Successful!"
        case .topUp: return "Top Up Successful!"
        case .withdraw: return "Withdraw Successful!"
        default: return "Purchase Successful!"
        }
    }

    func message() -> String {
        switch transaction.type {
        case .transfer: return "Your money has been transfered successfully!"
        case .topUp: return "Your money has been topped up successfully!"
        case .withdraw: return "Your money has been withdrawed successfully!"
        default: return "Your money has been purchased successfully!"
        }
    }

    func amount() -> String {
        return transaction.currency + String(transaction.amount)
    }

    func time() -> String {
        return transaction.time.formatDateTime()
    }

    func refId() -> String {
        return transaction.id
    }

    func amountName() -> String {
        switch transaction.type {
        case .transfer: return "Transfer Amount"
        case .topUp: return "Top Up Amount"
        case .withdraw: return "Withdraw Amount"
        default: return "Purchase Amount"
        }
    }

    func isTransferTransaction() -> Bool {
        return self.transaction.type == .transfer
    }
}
