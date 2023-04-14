//
//  ProfileInteractor+EditProfile.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import Foundation

extension ProfileInteractor: EditProfileListener {
    func editProfileWantToDismiss() {
        self.fetchUserInfor()
        self.listener?.profileWantToReloadUserInfor()
        self.router?.dismissEditProfile()
    }
}
