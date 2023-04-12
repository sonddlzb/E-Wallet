//
//  ProfileInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs
import RxSwift
import FirebaseAuth

protocol ProfileRouting: ViewableRouting {
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }

    func bindSignOutFailedResult(message: String)
}

protocol ProfileListener: AnyObject {
    func profileDidSignOut()
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?

    override init(presenter: ProfilePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - ProfilePresentableListener
extension ProfileInteractor: ProfilePresentableListener {
    func didTapSignOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            self.presenter.bindSignOutFailedResult(message: error.localizedDescription)
        }

        self.listener?.profileDidSignOut()
    }
}
