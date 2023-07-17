//
//  ProfileInteractor+Feedback.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import Foundation

extension ProfileInteractor: FeedbackListener {
    func feedbackWantToDismiss() {
        self.router?.dismissFeedback()
    }
}
