//
//  ReceiptInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 21/04/2023.
//

import RIBs
import RxSwift

protocol ReceiptRouting: ViewableRouting {
}

protocol ReceiptPresentable: Presentable {
    var listener: ReceiptPresentableListener? { get set }

    func bind(viewModel: ReceiptViewModel)
}

protocol ReceiptListener: AnyObject {
    func receiptWantToRouteToHome()
}

final class ReceiptInteractor: PresentableInteractor<ReceiptPresentable>, ReceiptInteractable {

    weak var router: ReceiptRouting?
    weak var listener: ReceiptListener?
    private var viewModel: ReceiptViewModel!

    init(presenter: ReceiptPresentable, transaction: Transaction) {
        self.viewModel = ReceiptViewModel(transaction: transaction)
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

// MARK: - ReceiptPresentableListener
extension ReceiptInteractor: ReceiptPresentableListener {
    func didTapHomeButton() {
        self.listener?.receiptWantToRouteToHome()
    }

    func didTapSeeDetailsButton() {
        self.listener?.receiptWantToRouteToHome()
        // route to see details history
    }
}
