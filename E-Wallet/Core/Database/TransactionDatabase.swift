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
            print("add new transaction")
        }
    }

    func fetchTransactionsBy(_ topic: String, completion: @escaping (_ listTransaction: [Transaction]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        var listTransactions: [Transaction] = []
        var query = self.database.collection(DatabaseConst.transactionPath).whereField("senderId", isEqualTo: userId)
        if topic != "All" {
            query = query.whereField("type", isEqualTo: topic)
        }

        query = query.order(by: "time", descending: true)
        self.fetchTransactionBy(query: query) { senderTransactions in
            listTransactions += senderTransactions

            query = self.database.collection(DatabaseConst.transactionPath).whereField("receiverId", isEqualTo: userId)
            if topic != "All" {
                query = query.whereField("type", isEqualTo: topic)
            }

            query = query.order(by: "time", descending: true)
            self.fetchTransactionBy(query: query) { receiverTransactions in
                listTransactions += receiverTransactions
                completion(Array(Set(listTransactions)).sorted {
                    return $0.time > $1.time
                })
            }
        }
    }

    func fetchTransactionBy(query: Query, completion: @escaping (_ listTransactions: [Transaction]) -> Void) {
        var listTransactions: [Transaction] = []
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let transactionId = document.documentID
                    guard let transactionData = try? JSONSerialization
                        .data(withJSONObject: document.data(), options: []) else {
                        continue
                    }

                    if let transactionEntity = try? JSONDecoder().decode(TransactionEntity.self, from: transactionData) {
                        listTransactions.append(Transaction(id: transactionId, entity: transactionEntity))
                    }
                }

                completion(Array(Set(listTransactions)).sorted {
                    return $0.time > $1.time
                })
            }
        }
    }

    func fetchTransactionsBy(key: String, currentTopic: String, completion: @escaping (_ listTransactions: [Transaction]) -> Void) {
        var listTransactions: [Transaction] = []
        var query: Query?
        if let amount = key.toDouble() {
            if currentTopic != "All" {
                query = self.database.collection(DatabaseConst.transactionPath).whereField("type", isEqualTo: currentTopic).whereField("amount", isEqualTo: amount)
            } else {
                query = self.database.collection(DatabaseConst.transactionPath).whereField("amount", isEqualTo: amount)
            }

            self.fetchTransactionBy(query: query!) { amountTransactions in
                listTransactions += amountTransactions
                completion(Array(Set(listTransactions)).sorted {
                    return $0.time > $1.time
                })
            }
        }
    }

    func filterTransaction(filterModel: FilterModel, completion: @escaping (_ listTransactions: [Transaction]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        var listTransactions: [Transaction] = []
        var query: Query = self.database.collection(DatabaseConst.transactionPath)
        if filterModel.status != "All" {
            query = query.whereField("status", isEqualTo: filterModel.status)
        }

        if filterModel.service != "All" {
            query = query.whereField("type", isEqualTo: filterModel.service)
        }

        if filterModel.month != "All" {
            if let startTime = filterModel.month.convertMonthAndYearToDate() {
                query = query
                    .whereField("time", isGreaterThan: startTime.timeIntervalSinceReferenceDate)
                    .whereField("time", isLessThan: startTime.endOfMonth().timeIntervalSinceReferenceDate)
            }
        }

        let querySender = query.whereField("senderId", isEqualTo: userId)
        self.fetchTransactionBy(query: querySender) { senderTransactions in
            listTransactions += senderTransactions

            var queryReceiver = query.whereField("receiverId", isEqualTo: userId)
            queryReceiver = queryReceiver.order(by: "time", descending: true)
            self.fetchTransactionBy(query: queryReceiver) { receiverTransactions in
                listTransactions += receiverTransactions
                let filteredListTransactions = Array(Set(listTransactions).filter {
                    $0.amount <= filterModel.endAmount && $0.amount >= filterModel.startAmount
                }).sorted {
                    return $0.time > $1.time
                }

                completion(filteredListTransactions)
            }
        }
    }

    func fetchTransactionBy(id: String, completion: @escaping (_ transaction: Transaction?) -> Void) {
        self.database.collection(DatabaseConst.transactionPath).document(id).getDocument { document, error in
            guard error == nil, let document = document else {
                completion(nil)
                return
            }

            let transactionId = document.documentID
            guard let transactionData = try? JSONSerialization
                .data(withJSONObject: document.data(), options: []) else {
                completion(nil)
                return
            }

            if let transactionEntity = try? JSONDecoder().decode(TransactionEntity.self, from: transactionData) {
                completion(Transaction(id: transactionId, entity: transactionEntity))
            }
        }
    }
}
