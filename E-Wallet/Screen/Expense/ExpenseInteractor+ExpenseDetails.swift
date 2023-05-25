//
//  ExpenseInteractor+ExpenseDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 24/05/2023.
//

import Foundation

extension ExpenseInteractor: ExpenseDetailsListener {
    func expenseDetailsWantToDismiss() {
        self.router?.dismissExpenseDetails()
    }
}
