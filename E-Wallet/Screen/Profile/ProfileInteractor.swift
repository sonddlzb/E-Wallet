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
    func bind(homeViewModel: HomeViewModel)
    func routeToEnterPassword(isNewUser: Bool, isConfirmPassword: Bool, password: String)
    func dismissEnterPassword()
    func bindAuthenticationResultToEnterPassword(isSuccess: Bool)
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }

    func bindSignOutFailedResult(message: String)
    func bind(homeViewModel: HomeViewModel)
    func bindChangePasswordResult(isSuccess: Bool, message: String)
}

protocol ProfileListener: AnyObject {
    func profileDidSignOut()
    func profileWantToReloadUserInfor()
    func profileWantToRouteToGift()
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable> {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?

    private var homeViewModel: HomeViewModel!

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

    func fetchUserInfor() {
        UserDatabase.shared.getUserInfor { user in
            if let user = user {
                self.homeViewModel.userEntity = user
                self.bind(homeViewModel: self.homeViewModel)
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
        guard self.homeViewModel != nil else {
            return
        }

        self.router?.routeToEditProfile(userEntity: self.homeViewModel.userEntity)
    }

    func didSelect(option: ProfileOption) {
        switch option {
        case .voucher:
            self.listener?.profileWantToRouteToGift()
        case .changePassword:
            self.router?.routeToEnterPassword(isNewUser: false, isConfirmPassword: false, password: "")
        default: print("not handle yet")
        }
    }
}

// MARK: - ProfileInteractable
extension ProfileInteractor: ProfileInteractable {
    func bind(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.presenter.bind(homeViewModel: homeViewModel)
    }
}
