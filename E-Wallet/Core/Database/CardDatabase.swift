//
//  CardDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 27/03/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CardDatabase {
    private var database = Firestore.firestore()
    static var shared = CardDatabase()

    func addNewCard(cardEntity: CardEntity, completion: @escaping (_ successfully: Bool?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        guard let cardDict = cardEntity.dict else {
            completion(false)
            return
        }

        self.database.collection(DatabaseConst.cardPath)
            .whereField("userId", isEqualTo: userId)
            .whereField("cardNumber", isEqualTo: cardEntity.cardNumber).getDocuments { querySnapshot, _ in
                guard querySnapshot?.isEmpty != false else {
                    print("This card has been added before!")
                    completion(false)
                    return
                }

                self.database.collection(DatabaseConst.cardPath).addDocument(data: cardDict) { error in
                    if let error = error {
                        print("Failed to add new card document \(error)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
    }

    func getListOfCards(completion: @escaping (_ listCards: [Card]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        self.database.collection(DatabaseConst.cardPath)
            .whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else if let querySnapshot = querySnapshot {
                var listCards: [Card] = []
                for document in querySnapshot.documents {
                    let cardId = document.documentID
                    guard let cardData = try? JSONSerialization
                        .data(withJSONObject: document.data(), options: []) else {
                        continue
                    }

                    if let cardEntity = try? JSONDecoder().decode(CardEntity.self, from: cardData) {
                        listCards.append(Card(id: cardId, entity: cardEntity))
                    }
                }

                completion(listCards)
            }
        }
    }

    func removeCard(_ cardId: String, completion: @escaping (_ error: Error?) -> Void) {
        self.database.collection(DatabaseConst.cardPath).document(cardId).delete { error in
            completion(error)
        }
    }
}
