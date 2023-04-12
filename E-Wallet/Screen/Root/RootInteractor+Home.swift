//
//  RootInteractor+Home.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import Foundation
import SVProgressHUD

extension RootInteractor: HomeListener {
    func routeToSignIn() {
        SVProgressHUD.show()

        // MARK: - Delay 0.3s for UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            SVProgressHUD.dismiss()
            self.router?.routeToSignIn()
        })
    }
}
