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
    func billDetailsWantToRouteToTransactionConfirn(confirmData: [String: String])
    func billDetailsWantToDismiss()
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
        let confirmData = ["Service": self.viewModel.supplier(),
                           "Customer ID": self.viewModel.customerId(),
                           "Customer Name": self.viewModel.customerName(),
                           "Address": self.viewModel.address(),
                           "Payment cycle": self.viewModel.period(),
                           "Amount": self.viewModel.amount(),
                           "Bill ID": self.viewModel.bill.id,
                           "Payment Type": self.viewModel.billType()]
        self.listener?.billDetailsWantToRouteToTransactionConfirn(confirmData: confirmData)
    }

    func didTapBackButton() {
        self.listener?.billDetailsWantToDismiss()
    }
}
