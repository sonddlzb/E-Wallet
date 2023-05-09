//
//  BillDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class BillDatabase {
    static var shared = BillDatabase()
    private var database = Firestore.firestore().collection(DatabaseConst.billPath)

    func getBillByCustomerId(_ customerId: String, serviceType: ServiceType, completion: @escaping (_ bill: Bill?) -> Void) {
        self.database.whereField("customerId", isEqualTo: customerId).whereField("type", isEqualTo: serviceType.rawValue).getDocuments { querySnapshot, error in
            if error != nil {
                completion(nil)
                return
            } else if let querySnapshot = querySnapshot, let document = querySnapshot.documents.first {
                let billId = document.documentID
                guard let billData = try? JSONSerialization.data(withJSONObject: document.data(), options: []) else {
                    completion(nil)
                    return
                }

                if let billEntity = try? JSONDecoder().decode(BillEntity.self, from: billData) {
                    completion(Bill(id: billId, entity: billEntity))
                }
            } else {
                completion(nil)
            }
        }
    }

    func updateBillStatus(billId: String, billStatus: BillStatus, completion: @escaping (_ isSuccess: Bool) -> Void) {
        self.database.document(billId).getDocument { document, error in
            guard error == nil, let document = document else {
                completion(false)
                return
            }

            guard let billData = try? JSONSerialization.data(withJSONObject: document.data(), options: []) else {
                completion(false)
                return
            }

            if let billEntity = try? JSONDecoder().decode(BillEntity.self, from: billData) {
                var updateBillEntity = billEntity
                updateBillEntity.status = billStatus.rawValue.capitalized
                if billStatus == .purchased {
                    updateBillEntity.amount = 0
                }

                if let dict = updateBillEntity.dict {
                    self.database.document(billId).updateData(dict) { error in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    }
                }
            }
        }
    }

    func getBillById(_ id: String, completion: @escaping (_ bill: Bill?) -> Void) {
        self.database.document(id).getDocument { document, error in
            guard error == nil, let document = document else {
                completion(nil)
                return
            }

            let billId = document.documentID
            guard let billData = try? JSONSerialization.data(withJSONObject: document.data(), options: []) else {
                completion(nil)
                return
            }

            if let billEntity = try? JSONDecoder().decode(BillEntity.self, from: billData) {
                completion(Bill(id: billId, entity: billEntity))
            }
        }
    }
}
