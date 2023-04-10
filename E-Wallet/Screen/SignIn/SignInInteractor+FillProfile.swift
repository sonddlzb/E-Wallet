//
//  SignInInteractor+FillProfile.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import Foundation
import SVProgressHUD

extension SignInInteractor: FillProfileListener {
    func fillProfileWantToDismiss() {
        self.router?.dismissFillProfile()
    }

    func fillProfileWantToSignUpNewUser(userEntity: UserEntity, avatar: UIImage) {
        let userEntityWithPhoneNumber = UserEntity(fullName: userEntity.fullName,
                                                   residentId: userEntity.residentId,
                                                   dateOfBirth: userEntity.dateOfBirth,
                                                   phoneNumber: self.phoneNumber,
                                                   nativePlace: userEntity.nativePlace,
                                                   gender: userEntity.gender,
                                                   avtURL: userEntity.avtURL,
                                                   password: self.password)
        SVProgressHUD.show()
        UserDatabase.shared.addNewUser(userEntity: userEntityWithPhoneNumber,
                                       image: avatar) { error in
            SVProgressHUD.dismiss()
            if error != nil {
                self.router?.bindSignUpResultToFillProfile(isSuccess: false)
            } else {
                self.router?.bindSignUpResultToFillProfile(isSuccess: true)
            }
        }
    }

    func fillProfileWantToRouteToHome() {
        self.listener?.routeToHome()
    }
}
