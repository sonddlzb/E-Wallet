//
//  FillProfileInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs
import RxSwift

protocol FillProfileRouting: ViewableRouting {
    func bindSignUpResult(isSuccess: Bool)
}

protocol FillProfilePresentable: Presentable {
    var listener: FillProfilePresentableListener? { get set }

    func bindSignUpResult(isSuccess: Bool)
}

protocol FillProfileListener: AnyObject {
    func fillProfileWantToDismiss()
    func fillProfileWantToSignUpNewUser(userEntity: UserEntity, avatar: UIImage)
    func fillProfileWantToRouteToHome()
}

final class FillProfileInteractor: PresentableInteractor<FillProfilePresentable> {

    weak var router: FillProfileRouting?
    weak var listener: FillProfileListener?

    override init(presenter: FillProfilePresentable) {
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

// MARK: - FillProfilePresentableListener
extension FillProfileInteractor: FillProfilePresentableListener {
    func isFullNameValid(fullName: String) -> Bool {
        return !fullName.isEmpty
    }

    func isResidentIDValid(residentId: String) -> Bool {
        return residentId.isResidentIDValid()
    }

    func isDateOfBirthValid(dateOfBirth: String) -> Bool {
        guard dateOfBirth.convertToDate() != nil else {
            return false
        }

        return true
    }

    func isNativePlaceValid(nativePlace: String) -> Bool {
        return !nativePlace.isEmpty
    }

    func isGenderValid(gender: String) -> Bool {
        return gender != "Gender"
    }

    func fillProfileWantToDismiss() {
        self.listener?.fillProfileWantToDismiss()
    }

    func fillProfileWantToSignUpNewUser(userEntity: UserEntity, avatar: UIImage) {
        self.listener?.fillProfileWantToSignUpNewUser(userEntity: userEntity, avatar: avatar)
    }

    func fillProfileWantToRouteToHome() {
        self.listener?.fillProfileWantToRouteToHome()
    }
}

// MARK: - FillProfileInteractable
extension FillProfileInteractor: FillProfileInteractable {
    func bindSignUpResult(isSuccess: Bool) {
        self.presenter.bindSignUpResult(isSuccess: isSuccess)
    }
}
