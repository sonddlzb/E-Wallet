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
}
