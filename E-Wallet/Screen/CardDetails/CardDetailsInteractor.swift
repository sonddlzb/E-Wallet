//
//  CardDetailsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 16/04/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol CardDetailsRouting: ViewableRouting {
}

protocol CardDetailsPresentable: Presentable {
    var listener: CardDetailsPresentableListener? { get set }

    func bind(viewModel: CardDetailsViewModel)
    func bindRemoveCardResult(isSuccess: Bool, message: String)
}

protocol CardDetailsListener: AnyObject {
    func cardDetailsWantToDismiss()
    func cardDetailsWantToReloadData()
}

final class CardDetailsInteractor: PresentableInteractor<CardDetailsPresentable>, CardDetailsInteractable {

    weak var router: CardDetailsRouting?
    weak var listener: CardDetailsListener?

    private var viewModel: CardDetailsViewModel!

    init(presenter: CardDetailsPresentable, card: Card) {
        self.viewModel = CardDetailsViewModel(card: card)
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

// MARK: - CardDetailsPresentableListener
extension CardDetailsInteractor: CardDetailsPresentableListener {
    func backButtonDidTap() {
        self.listener?.cardDetailsWantToDismiss()
    }

    func removeCard() {
        SVProgressHUD.show()
        CardDatabase.shared.removeCard(self.viewModel.card.id) { error in
            SVProgressHUD.dismiss()
            if let error = error {
                self.presenter.bindRemoveCardResult(isSuccess: false, message: error.localizedDescription)
            } else {
                self.presenter.bindRemoveCardResult(isSuccess: true, message: "This card had been removed from your payment!")
            }
        }
    }

    func reloadData() {
        self.listener?.cardDetailsWantToReloadData()
    }
}
