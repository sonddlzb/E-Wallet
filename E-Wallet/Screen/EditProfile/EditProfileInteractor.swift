//
//  EditProfileInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol EditProfileRouting: ViewableRouting {
}

protocol EditProfilePresentable: Presentable {
    var listener: EditProfilePresentableListener? { get set }

    func bind(viewModel: EditProfileViewModel)
    func bindUpdateResult(isSuccess: Bool)
}

protocol EditProfileListener: AnyObject {
    func editProfileWantToDismiss()
}

final class EditProfileInteractor: PresentableInteractor<EditProfilePresentable>, EditProfileInteractable {

    weak var router: EditProfileRouting?
    weak var listener: EditProfileListener?

    private var viewModel: EditProfileViewModel!

    init(presenter: EditProfilePresentable, userEntity: UserEntity) {
        self.viewModel = EditProfileViewModel(userEntity: userEntity)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - EditProfilePresentableListener
extension EditProfileInteractor: EditProfilePresentableListener {
    func editProfileWantToDismiss() {
        self.listener?.editProfileWantToDismiss()
    }

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

    func editProfileWantToUpdate(userEntity: UserEntity, avatar: UIImage) {
        SVProgressHUD.show()
        UserDatabase.shared.updateProfile(profile: userEntity) { successfully in
            SVProgressHUD.dismiss()
            self.presenter.bindUpdateResult(isSuccess: successfully == true)
        }
    }
}
