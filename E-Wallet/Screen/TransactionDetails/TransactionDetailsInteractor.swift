//
//  TransactionDetailsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 27/04/2023.
//

import RIBs
import RxSwift

protocol TransactionDetailsRouting: ViewableRouting {
}

protocol TransactionDetailsPresentable: Presentable {
    var listener: TransactionDetailsPresentableListener? { get set }

    func bind(viewModel: TransactionDetailsViewModel)
    func bindCopyResult(isSuccess: Bool)
    func bind(viewModel: BillDetailsViewModel)
}

protocol TransactionDetailsListener: AnyObject {
    func transactionDetailsWantToDismiss()
}

final class TransactionDetailsInteractor: PresentableInteractor<TransactionDetailsPresentable>, TransactionDetailsInteractable {

    weak var router: TransactionDetailsRouting?
    weak var listener: TransactionDetailsListener?
    private var viewModel: TransactionDetailsViewModel

    init(presenter: TransactionDetailsPresentable, transaction: Transaction) {
        self.viewModel = TransactionDetailsViewModel(transaction: transaction)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
        var billTypes: [PaymentType] = [.electricity, .internet, .water, .televison]
        if billTypes.contains(self.viewModel.transaction.type) {
            self.fetchBillData()
        }
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchBillData() {
        BillDatabase.shared.getBillById(self.viewModel.transaction.receiverId) { bill in
            if let bill = bill {
                DispatchQueue.main.async {
                    self.presenter.bind(viewModel: BillDetailsViewModel(bill: bill))
                }
            }
        }
    }
}

extension TransactionDetailsInteractor: TransactionDetailsPresentableListener {
    func copyTransactionId(_ id: String) {
        UIPasteboard.general.string = id
        self.presenter.bindCopyResult(isSuccess: true)
    }

    func didTapBackButton() {
        self.listener?.transactionDetailsWantToDismiss()
    }
}
