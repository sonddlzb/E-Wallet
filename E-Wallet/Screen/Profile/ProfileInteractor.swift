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
    func routeToEditProfile(userEntity: UserEntity)
    func dismissEditProfile()
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }

    func bindSignOutFailedResult(message: String)
    func bind(viewModel: ProfileViewModel)
}

protocol ProfileListener: AnyObject {
    func profileDidSignOut()
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?

    private var viewModel: ProfileViewModel!

    override init(presenter: ProfilePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchUserInfor()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchUserInfor() {
        UserDatabase.shared.getUserInfor { user in
            if let user = user {
                self.viewModel = ProfileViewModel(userEntity: user)
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
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

    func didTapEditProfile() {
        guard self.viewModel != nil else {
            return
        }

        self.router?.routeToEditProfile(userEntity: self.viewModel.userEntity)
    }
}
