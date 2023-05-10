//
//  VoucherDetailsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs
import RxSwift

protocol VoucherDetailsRouting: ViewableRouting {
}

protocol VoucherDetailsPresentable: Presentable {
    var listener: VoucherDetailsPresentableListener? { get set }

    func bind(viewModel: VoucherDetailsViewModel)
    func bindNotReadyToUseResult()
}

protocol VoucherDetailsListener: AnyObject {
    func voucherDetailsWantToDismiss()
    func voucherDetailsWantTransactionConfirmToUse(voucher: Voucher)
}

final class VoucherDetailsInteractor: PresentableInteractor<VoucherDetailsPresentable>, VoucherDetailsInteractable {

    weak var router: VoucherDetailsRouting?
    weak var listener: VoucherDetailsListener?
    var viewModel: VoucherDetailsViewModel
    var isFromGift: Bool

    init(presenter: VoucherDetailsPresentable, voucher: Voucher, isFromGift: Bool) {
        self.isFromGift = isFromGift
        self.viewModel = VoucherDetailsViewModel(voucher: voucher)
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

// MARK: - VoucherDetailsPresentableListener
extension VoucherDetailsInteractor: VoucherDetailsPresentableListener {
    func didTapBackButton() {
        self.listener?.voucherDetailsWantToDismiss()
    }

    func didTapUseNow() {
        guard self.viewModel.isReadyToUse() else {
            self.presenter.bindNotReadyToUseResult()
            return
        }

        if !self.isFromGift {
            self.listener?.voucherDetailsWantTransactionConfirmToUse(voucher: self.viewModel.voucher)
        } else {
            // handle later
        }
    }
}
