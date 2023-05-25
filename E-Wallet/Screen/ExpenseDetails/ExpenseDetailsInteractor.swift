//
//  ExpenseDetailsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 24/05/2023.
//

import RIBs
import RxSwift
import FirebaseAuth

protocol ExpenseDetailsRouting: ViewableRouting {
}

protocol ExpenseDetailsPresentable: Presentable {
    var listener: ExpenseDetailsPresentableListener? { get set }

    func bind(viewModel: ExpenseDetailsViewModel)
}

protocol ExpenseDetailsListener: AnyObject {
    func expenseDetailsWantToDismiss()
}

final class ExpenseDetailsInteractor: PresentableInteractor<ExpenseDetailsPresentable>, ExpenseDetailsInteractable {

    weak var router: ExpenseDetailsRouting?
    weak var listener: ExpenseDetailsListener?
    private var startDate: Date
    var viewModel = ExpenseDetailsViewModel.makeEmpty()

    init(presenter: ExpenseDetailsPresentable, startDate: Date) {
        self.startDate = startDate
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let filterModel = FilterModel(month: startDate.monthName(), service: "All", startAmount: 0.0, endAmount: 2000.0, status: "completed")
        TransactionDatabase.shared.filterTransaction(filterModel: filterModel) { listTransactions in
            self.viewModel = ExpenseDetailsViewModel(listTransactions: listTransactions.filter {
                !($0.type == .topUp || ($0.type == .transfer && $0.receiverId == userId))
            }, startDate: self.startDate)
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}

// MARK: - ExpenseDetailsPresentableListener
extension ExpenseDetailsInteractor: ExpenseDetailsPresentableListener {
    func didTapBack() {
        self.listener?.expenseDetailsWantToDismiss()
    }
}
