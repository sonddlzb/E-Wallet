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

    func fetchVouchersBy(paymentType: PaymentType, amount: Double, completion: @escaping (_ listVouchers: [Voucher]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.database.whereField("userId", isEqualTo: userId).whereField("serviceTypes", arrayContains: paymentType.rawValue).whereField("minValue", isLessThanOrEqualTo: amount).getDocuments { querySnapshot, err in
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

    func removeVoucher(voucherId: String) {
        self.database.document(voucherId).delete()
    }

    // only for test
    func createVoucher(voucherEntity: VoucherEntity, completion: @escaping (_ successfully: Bool?) -> Void) {
        guard let voucherEntity = voucherEntity.dict else {
            completion(false)
            return
        }

        self.database.addDocument(data: voucherEntity) { error in
            if let error = error {
                print("Failed to add new card document \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
