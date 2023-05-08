//
//  BillDetailsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import RIBs
import RxSwift

protocol BillDetailsRouting: ViewableRouting {
}

protocol BillDetailsPresentable: Presentable {
    var listener: BillDetailsPresentableListener? { get set }

    func bind(viewModel: BillDetailsViewModel)
}

protocol BillDetailsListener: AnyObject {
}

final class BillDetailsInteractor: PresentableInteractor<BillDetailsPresentable>, BillDetailsInteractable {

    weak var router: BillDetailsRouting?
    weak var listener: BillDetailsListener?
    var viewModel: BillDetailsViewModel

    init(presenter: BillDetailsPresentable, bill: Bill) {
        self.viewModel = BillDetailsViewModel(bill: bill)
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

// MARK: - BillDetailsPresentableListener
extension BillDetailsInteractor: BillDetailsPresentableListener {
    func didTapCheckout() {
        // handle checkout
    }
}
