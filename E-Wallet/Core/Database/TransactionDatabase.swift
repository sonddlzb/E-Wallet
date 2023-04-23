//
//  TransactionDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TransactionDatabase {
    static let shared = TransactionDatabase()
    private var database = Firestore.firestore()

    func addNewTransaction(entity: TransactionEntity, completion: @escaping (_ error: Error?, _ documentId: String?) -> Void) {
        var ref: DocumentReference?
        ref = self.database.collection(DatabaseConst.transactionPath).addDocument(data: entity.dict ?? [:]) { error in
            completion(error, ref?.documentID)
        }
    }
}
