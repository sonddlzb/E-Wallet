//
//  FeedbackDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import UIKit

class FeedbackDatabase {
    private var feedbackRef = Firestore.firestore().collection(DatabaseConst.feedbackPath)
    static var shared = FeedbackDatabase()

    func addFeedback(email: String, feedback: String, rating: FeedbackType, completion: @escaping (_ error: Error?, _ isSuccess: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, false)
            return
        }

        let feedbackEntity = FeedbackEntity(email: email, rating: rating.rawValue, feedback: feedback, userId: userId)

        guard let feedbackDict = feedbackEntity.dict else {
            completion(nil, false)
            return
        }

        self.feedbackRef.addDocument(data: feedbackDict) { error in
            if let error = error {
                print("Failed to send feedback: \(error)")
                completion(error, false)
            } else {
                completion(nil, true)
            }
        }
    }
}
