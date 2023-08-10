//
//  TransactionDetailsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import Foundation
import UIKit
import FirebaseAuth

struct TransactionDetailsViewModel {
    var transaction: Transaction

    func status() -> String {
        return transaction.status.rawValue.capitalized
    }

    func time() -> String {
        return transaction.time.formatDateTime()
    }

    func description() -> String {
        return transaction.description
    }

    func receiverInfor(completion: @escaping (_ phoneNumber: String, _ name: String) -> Void) {
        UserDatabase.shared.getUserBy(id: self.transaction.receiverId) { userEntity in
            DispatchQueue.main.async {
                completion(userEntity?.phoneNumber ?? "", userEntity?.fullName ?? "")
            }
        }
    }

    func image() -> UIImage? {
        return UIImage(named: "ic_\(self.transaction.type.rawValue.lowercased())_history")
    }

    func message() -> String {
        return self.transaction.message
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

    func title() -> String {
        return self.transaction.type.rawValue.uppercased() + " MONEY"
    }

    func transationId() -> String {
        return self.transaction.id
    }
}
