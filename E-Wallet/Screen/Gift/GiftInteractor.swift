//
//  GiftInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import RIBs
import RxSwift

protocol GiftRouting: ViewableRouting {
    func routeToVoucherDetails(voucher: Voucher)
    func dissmissVoucherDetails()
    func routeToGiftArea(voucher: Voucher)
    func dismissGiftArea()
}

protocol GiftPresentable: Presentable {
    var listener: GiftPresentableListener? { get set }

    func bind(viewModel: GiftViewModel)
    func stopLoadingEffect()
    func bindNotReadyState(at voucher: Voucher)
}

protocol GiftListener: AnyObject {
    func giftWantToOpenService(_ serviceType: ServiceType)
}

final class GiftInteractor: PresentableInteractor<GiftPresentable>, GiftInteractable {

    weak var router: GiftRouting?
    weak var listener: GiftListener?
    var viewModel = GiftViewModel.makeEmpty()

    override init(presenter: GiftPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchVouchers()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchVouchers() {
        VoucherDatabase.shared.fetchVouchers { listVouchers in
            let updateViewModel = GiftViewModel(listVouchers: listVouchers)
            if updateViewModel != self.viewModel {
                self.viewModel = updateViewModel
                DispatchQueue.main.async {
                    self.presenter.bind(viewModel: self.viewModel)
                }
            }

            DispatchQueue.main.async {
                self.presenter.stopLoadingEffect()
            }
        }
    }
}

// MARK: - GiftPresentableListener
extension GiftInteractor: GiftPresentableListener {
    func reloadDataIfNeed() {
        self.fetchVouchers()
    }

    func didSelect(voucher: Voucher) {
        self.router?.routeToVoucherDetails(voucher: voucher)
    }

    func didTapUseNow(itemViewModel: GiftItemViewModel) {
        guard itemViewModel.isReadyToUse() else {
            self.presenter.bindNotReadyState(at: itemViewModel.voucher)
            return
        }

        self.router?.routeToGiftArea(voucher: itemViewModel.voucher)
    }
}
