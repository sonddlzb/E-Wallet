//
//  Feedback.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import Foundation

class Feedback {
    var id: String
    var feedback: String
    var email: String
    var rating: FeedbackType
    var userId: String

    init(id: String, feedback: String, email: String, rating: FeedbackType, userId: String) {
        self.id = id
        self.feedback = feedback
        self.email = email
        self.rating = rating
        self.userId = userId
    }

    init(id: String, entity: FeedbackEntity) {
        self.id = id
        self.email = entity.email
        self.feedback = entity.feedback
        self.rating = FeedbackType(rawValue: entity.rating) ?? .fine
        self.userId = entity.userId
    }
}
