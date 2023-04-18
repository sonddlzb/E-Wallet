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

    func topUp(amount: Double, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.accountRef.child(userId).getData { error, snapshot in
            if let error = error {
                completion(error)
            } else {
                if let dict = snapshot?.value as? [String: Any], let balance = dict["balance"] as? Double {
                    self.accountRef.child(userId).updateChildValues(["balance": balance + amount]) { error, _ in
                        print("update")
                        completion(error)
                    }
                }
            }
        }
    }

    func withdraw(amount: Double, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.accountRef.child(userId).getData { error, snapshot in
            if let error = error {
                completion(error)
            } else {
                if let dict = snapshot?.value as? [String: Any], let balance = dict["balance"] as? Double {
                    guard balance >= amount else {
                        completion(AccountError.insufficientBalance("Your balance is not enough"))
                        return
                    }

                    self.accountRef.child(userId).updateChildValues(["balance": balance - amount]) { error, _ in
                        print("update")
                        completion(error)
                    }
                }
            }
        }
    }
}
