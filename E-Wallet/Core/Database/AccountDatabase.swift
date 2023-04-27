//
//  AccountDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

enum AccountError: Error {
    case insufficientBalance(String)
    case invalidReceiver(String)
}

class AccountDatabase {
    private var accountRef = Database.database().reference().child(DatabaseConst.accountPath)
    static var shared = AccountDatabase()

    func createNewAccount(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let newAccountEntity = AccountEntity(currency: "$", balance: 0, isActive: true)
        self.accountRef.child(userId).setValue(newAccountEntity.dict) { error, _ in
            if let error = error {
                print("Failed to add new review: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func getAccountInfor(completion: @escaping (_ accountEntity: AccountEntity) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.accountRef.child(userId).observe(.value, with: { snapshot in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                return
            }

            let entity = AccountEntity(currency: dict["currency"] as? String ?? "$",
                                       balance: dict["balance"] as? Double ?? 0.0,
                                       isActive: dict["isActive"] as? Bool ?? false)
            completion(entity)
        })
    }

    func topUp(amount: Double, completion: @escaping (_ error: Error?, _ transaction: Transaction?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.accountRef.child(userId).getData { error, snapshot in
            if let error = error {
                completion(error, nil)
            } else {
                if let dict = snapshot?.value as? [String: Any], let balance = dict["balance"] as? Double {
                    self.accountRef.child(userId).updateChildValues(["balance": balance + amount]) { error, _ in
                        guard error == nil else {
                            completion(error, nil)
                            return
                        }

                        let transactionEntity = TransactionEntity(type: PaymentType.topUp.rawValue,
                                                                  senderId: userId,
                                                                  receiverId: userId,
                                                                  amount: amount,
                                                                  currency: "$",
                                                                  status: PaymentStatus.completed.rawValue,
                                                                  time: Date(),
                                                                  description: "Top Up transaction")
                        TransactionDatabase.shared.addNewTransaction(entity: transactionEntity) { error, transactionId in
                            if let error = error {
                                print("Create transaction failed with error \(error.localizedDescription)")
                            } else {
                                print("Create transaction successfully")
                                if let transactionId = transactionId {
                                    completion(nil, Transaction(id: transactionId, entity: transactionEntity))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func withdraw(amount: Double, completion: @escaping (_ error: Error?, _ transaction: Transaction?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.accountRef.child(userId).getData { error, snapshot in
            if let error = error {
                completion(error, nil)
            } else {
                if let dict = snapshot?.value as? [String: Any], let balance = dict["balance"] as? Double {
                    guard balance >= amount else {
                        completion(AccountError.insufficientBalance("Your balance is not enough"), nil)
                        return
                    }

                    self.accountRef.child(userId).updateChildValues(["balance": balance - amount]) { error, _ in
                        guard error == nil else {
                            completion(error, nil)
                            return
                        }

                        let transactionEntity = TransactionEntity(type: PaymentType.withdraw.rawValue,
                                                                  senderId: userId,
                                                                  receiverId: userId,
                                                                  amount: amount,
                                                                  currency: "$",
                                                                  status: PaymentStatus.completed.rawValue,
                                                                  time: Date(),
                                                                  description: "Withdraw transaction")
                        TransactionDatabase.shared.addNewTransaction(entity: transactionEntity) { error, transactionId in
                            if let error = error {
                                print("Create transaction failed with error \(error.localizedDescription)")
                            } else {
                                print("Create transaction successfully")
                                if let transactionId = transactionId {
                                    completion(nil, Transaction(id: transactionId, entity: transactionEntity))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func getAccountInforBy(userId: String, completion: @escaping (_ accountEntity: AccountEntity) -> Void) {
        self.accountRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                return
            }

            let entity = AccountEntity(currency: dict["currency"] as? String ?? "$",
                                       balance: dict["balance"] as? Double ?? 0.0,
                                       isActive: dict["isActive"] as? Bool ?? false)
            completion(entity)
        }) { error in
            print(error.localizedDescription)
        }    }

    func transfer(selectedCard: Card?, amount: Double, receiverPhoneNumber: String, completion: @escaping (_ error: Error?, _ transaction: Transaction?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        guard Auth.auth().currentUser?.phoneNumber != receiverPhoneNumber else {
            completion(AccountError.invalidReceiver("You can not send money to your account"), nil)
            return
        }

        if let card = selectedCard {
            STPPaymentHelper.shared.handlePayment(card: card, price: amount, paymentType: .topUp, completion: {[weak self] error in
                if let error = error {
                    completion(error, nil)
                    return
                } else {
                    self?.topUp(amount: amount) { error, transaction in
                        if let error = error {
                            completion(error, nil)
                            return
                        } else {
                            self?.transferWithBalance(amount: amount, receiverPhoneNumber: receiverPhoneNumber, completion: completion)
                        }
                    }
                }
            })
        } else {
            self.transferWithBalance(amount: amount, receiverPhoneNumber: receiverPhoneNumber, completion: completion)
        }
    }

    func transferWithBalance(amount: Double, receiverPhoneNumber: String, completion: @escaping (_ error: Error?, _ transaction: Transaction?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        var receiverID = ""
        self.accountRef.child(userId).getData { error, snapshot in
            if let error = error {
                completion(error, nil)
            } else {
                if let dict = snapshot?.value as? [String: Any], let balance = dict["balance"] as? Double {
                    guard balance >= amount else {
                        completion(AccountError.insufficientBalance("Your balance is not enough"), nil)
                        return
                    }

                    self.accountRef.child(userId).updateChildValues(["balance": balance - amount]) { error, _ in
                        guard error == nil else {
                            completion(error, nil)
                            return
                        }

                        UserDatabase.shared.getUserBy(phoneNumber: receiverPhoneNumber) { receiver in
                            guard let receiver = receiver else {
                                completion(AccountError.invalidReceiver("Invalid receiver"), nil)
                                return
                            }

                            receiverID = receiver.id
                            AccountDatabase.shared.getAccountInforBy(userId: receiverID) { accountEntity in
                                self.accountRef.child(receiverID).updateChildValues(["balance": accountEntity.balance + amount]) { error, _ in
                                    guard error == nil else {
                                        completion(error, nil)
                                        return
                                    }

                                    let transactionEntity = TransactionEntity(type: PaymentType.transfer.rawValue,
                                                                              senderId: userId,
                                                                              receiverId: receiverID,
                                                                              amount: amount,
                                                                              currency: "$",
                                                                              status: PaymentStatus.completed.rawValue,
                                                                              time: Date(),
                                                                              description: "Transfer money to \(receiver.fullName)")
                                    TransactionDatabase.shared.addNewTransaction(entity: transactionEntity) { error, transactionId in
                                        if let error = error {
                                            print("Create transaction failed with error \(error.localizedDescription)")
                                        } else {
                                            print("Create transaction successfully")
                                            if let transactionId = transactionId {
                                                completion(nil, Transaction(id: transactionId, entity: transactionEntity))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
