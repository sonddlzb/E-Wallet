//
//  HistoryInteractor+Filter.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import Foundation
import SVProgressHUD

extension HistoryInteractor: FilterListener {
    func filterWantToDismiss() {
        self.router?.dismissFilter()
    }

    func filterWantToSave(filterModel: FilterModel) {
        self.previousFilterModel = filterModel
    }

    func filterWantToFilterHistory(filterModel: FilterModel) {
        self.isInFilterMode = true
        SVProgressHUD.show()
        TransactionDatabase.shared.filterTransaction(filterModel: filterModel) { listTransactions in
            self.viewModel = HistoryViewModel(listTransaction: listTransactions)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.router?.dismissFilter()
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}
