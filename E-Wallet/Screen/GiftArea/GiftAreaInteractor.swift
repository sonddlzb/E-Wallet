//
//  GiftAreaInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import RIBs
import RxSwift

protocol GiftAreaRouting: ViewableRouting {
}

protocol GiftAreaPresentable: Presentable {
    var listener: GiftAreaPresentableListener? { get set }

    func bind(viewModel: ServiceViewModel)
}

protocol GiftAreaListener: AnyObject {
    func giftAreaWantToDismiss()
    func giftAreaWantToOpenService(_ serviceType: ServiceType)
}

final class GiftAreaInteractor: PresentableInteractor<GiftAreaPresentable>, GiftAreaInteractable {

    weak var router: GiftAreaRouting?
    weak var listener: GiftAreaListener?
    var viewModel: ServiceViewModel

    init(presenter: GiftAreaPresentable, voucher: Voucher) {
        self.viewModel = ServiceViewModel(listServices: voucher.serviceTypes)
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

// MARK: - GiftAreaPresentableListener
extension GiftAreaInteractor: GiftAreaPresentableListener {
    func openService(_ serviceType: ServiceType) {
        self.listener?.giftAreaWantToOpenService(serviceType)
    }

    func didTapBack() {
        self.listener?.giftAreaWantToDismiss()
    }
}
