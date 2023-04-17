//
//  AccountInteractor+CardDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

extension AccountInteractor: CardDetailsListener {
    func cardDetailsWantToDismiss() {
        self.router?.dismissCardDetails()
    }

    func cardDetailsWantToReloadData() {
        self.fetchAccounts()
        self.router?.dismissCardDetails()
    }
}
