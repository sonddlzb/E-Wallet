//
//  VoucherDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class VoucherDatabase {
    private var database = Firestore.firestore().collection(DatabaseConst.voucherPath)
    static var shared = VoucherDatabase()

    func fetchVouchers(completion: @escaping (_ listVouchers: [Voucher]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.database.whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else if let querySnapshot = querySnapshot {
                var listVouchers: [Voucher] = []
                for document in querySnapshot.documents {
                    let voucherId = document.documentID
                    guard let voucherData = try? JSONSerialization
                        .data(withJSONObject: document.data(), options: []) else {
                        continue
                    }

                    if let voucherEntity = try? JSONDecoder().decode(VoucherEntity.self, from: voucherData) {
                        listVouchers.append(Voucher(id: voucherId, entity: voucherEntity))
                    }
                }

                completion(listVouchers)
            }
        }
    }
}
