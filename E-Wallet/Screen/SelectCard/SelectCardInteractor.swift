//
//  SelectCardInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import RIBs
import RxSwift

protocol SelectCardRouting: ViewableRouting {
}

protocol SelectCardPresentable: Presentable {
    var listener: SelectCardPresentableListener? { get set }

    func bind(viewModel: CardViewModel, balance: Double)
    func bindSelectedCard(_ selectedCard: Card?)
}

protocol SelectCardListener: AnyObject {
    func selectCardWantToDismiss()
    func selectCardDidSelectAt(indexPath: IndexPath)
    func selectCardWantToRouteToAddNewCard()
}

final class SelectCardInteractor: PresentableInteractor<SelectCardPresentable>, SelectCardInteractable {

    weak var router: SelectCardRouting?
    weak var listener: SelectCardListener?
    private var viewModel = CardViewModel.makeEmpty()
    private var selectedCard: Card?

    init(presenter: SelectCardPresentable, selectedCard: Card?) {
        self.selectedCard = selectedCard
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchAccounts()
        self.presenter.bindSelectedCard(self.selectedCard)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchAccounts() {
        CardDatabase.shared.getListOfCards { [weak self] listCards in
            guard let self = self else {
                return
            }

            self.viewModel = CardViewModel(listCards: listCards)
            AccountDatabase.shared.getAccountInfor { [weak self] accountEntity in
                guard let self = self else {
                    return
                }

                DispatchQueue.main.async {
                    self.presenter.bind(viewModel: self.viewModel, balance: accountEntity.balance)
                }
            }
        }
    }
}

// MARK: - SelectCardPresentableListener
extension SelectCardInteractor: SelectCardPresentableListener {
    func didTapCancelButton() {
        self.listener?.selectCardWantToDismiss()
    }

    func didSelectAt(indexPath: IndexPath) {
        self.listener?.selectCardDidSelectAt(indexPath: indexPath)
    }

    func didSelectAddNewCard() {
        self.listener?.selectCardWantToRouteToAddNewCard()
    }
}
