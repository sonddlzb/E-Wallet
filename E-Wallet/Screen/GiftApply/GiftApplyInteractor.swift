//
//  GiftApplyInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 09/05/2023.
//

import RIBs
import RxSwift

protocol GiftApplyRouting: ViewableRouting {
    func routeToVoucherDetails(voucher: Voucher)
    func dismissVoucherDetails(animated: Bool)
}

protocol GiftApplyPresentable: Presentable {
    var listener: GiftApplyPresentableListener? { get set }

    func bind(viewModel: GiftApplyViewModel)
}

protocol GiftApplyListener: AnyObject {
    func giftApplyWantToDismiss()
    func giftApplyWantToApply(voucher: Voucher)
    func giftDetailsWantTransactionConfirmToUse(voucher: Voucher)
}

final class GiftApplyInteractor: PresentableInteractor<GiftApplyPresentable>, GiftApplyInteractable {

    weak var router: GiftApplyRouting?
    weak var listener: GiftApplyListener?
    var viewModel = GiftApplyViewModel.makeEmpty()
    var paymentType: PaymentType
    var amount: Double

    init(presenter: GiftApplyPresentable, paymentType: PaymentType, amount: Double) {
        self.amount = amount
        self.paymentType = paymentType
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchListVouchers()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchListVouchers() {
        VoucherDatabase.shared.fetchVouchersBy(paymentType: self.paymentType, amount: self.amount) { listVouchers in
            self.viewModel = GiftApplyViewModel(listVouchers: listVouchers)
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}

// MARK: - GiftApplyPresentableListener
extension GiftApplyInteractor: GiftApplyPresentableListener {
    func didTapBackButton() {
        self.listener?.giftApplyWantToDismiss()
    }

    func shouldApply(voucher: Voucher) {
        self.listener?.giftApplyWantToApply(voucher: voucher)
    }

    func tapToSeeDetails(voucher: Voucher) {
        self.router?.routeToVoucherDetails(voucher: voucher)
    }
}
