//
//  EnterBillInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol EnterBillRouting: ViewableRouting {
    func routeToBillDetails(bill: Bill)
    func dismissBillDetails()
}

protocol EnterBillPresentable: Presentable {
    var listener: EnterBillPresentableListener? { get set }

    func bindCheckBillFailedResult()
    func bind(viewModel: EnterBillViewModel)
}

protocol EnterBillListener: AnyObject {
    func enterBillWantToDismiss()
    func billDetailsWantToRouteToTransactionConfirn(confirmData: [String: String])
}

final class EnterBillInteractor: PresentableInteractor<EnterBillPresentable>, EnterBillInteractable {

    weak var router: EnterBillRouting?
    weak var listener: EnterBillListener?
    var viewModel: EnterBillViewModel

    init(presenter: EnterBillPresentable, serviceType: ServiceType) {
        self.viewModel = EnterBillViewModel(serviceType: serviceType)
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

// MARK: - EnterBillPresentableListener
extension EnterBillInteractor: EnterBillPresentableListener {
    func didTapBackButton() {
        self.listener?.enterBillWantToDismiss()
    }

    func didSelectCheck(customerId: String) {
        SVProgressHUD.show()
        BillDatabase.shared.getBillByCustomerId(customerId, serviceType: self.viewModel.serviceType) { bill in
            SVProgressHUD.dismiss()
            if let bill = bill {
                self.router?.routeToBillDetails(bill: bill)
            } else {
                DispatchQueue.main.async {
                    self.presenter.bindCheckBillFailedResult()
                }
            }
        }
    }
}
