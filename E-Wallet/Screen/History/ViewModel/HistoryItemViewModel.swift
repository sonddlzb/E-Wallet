//
//  HistoryItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import Foundation
import FirebaseAuth
import UIKit

struct HistoryItemViewModel {
    var transaction: Transaction

    func description() -> String {
        return transaction.description
    }

    func time() -> String {
        return self.transaction.time.formatDateTime()
    }

    func amount() -> String {
        switch self.transaction.type {
        case .topUp: return "+$" + String(self.transaction.amount)
        case .transfer:
            guard let userId = Auth.auth().currentUser?.uid else {
                return ""
            }

            if self.transaction.senderId == userId {
                return "-$" + String(self.transaction.amount)
            } else {
                return "+S" + String(self.transaction.amount)
            }

        default:
            return "-$" + String(self.transaction.amount)
        }
    }

    func image() -> UIImage? {
        return UIImage(named: "ic_\(self.transaction.type.rawValue.lowercased())_history")
    }
}
