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
    }

    override func willResignActive() {
        super.willResignActive()
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
