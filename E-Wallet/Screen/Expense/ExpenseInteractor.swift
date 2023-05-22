//
//  ExpenseInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import RIBs
import RxSwift

protocol ExpenseRouting: ViewableRouting {
}

protocol ExpensePresentable: Presentable {
    var listener: ExpensePresentableListener? { get set }

    func bind(viewModel: ExpenseViewModel)
}

protocol ExpenseListener: AnyObject {
    func expenseWantToDismiss()
}

final class ExpenseInteractor: PresentableInteractor<ExpensePresentable>, ExpenseInteractable {

    weak var router: ExpenseRouting?
    weak var listener: ExpenseListener?
    var viewModel = ExpenseViewModel.makeEmpty()

    override init(presenter: ExpensePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchTransactionsData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchTransactionsData() {
        TransactionDatabase.shared.fetchTransactionsBy("All") { listTransaction in
            self.viewModel = ExpenseViewModel(listTransactions: listTransaction)
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}

extension ExpenseInteractor: ExpensePresentableListener {
    func didTapBack() {
        self.listener?.expenseWantToDismiss()
    }
}
