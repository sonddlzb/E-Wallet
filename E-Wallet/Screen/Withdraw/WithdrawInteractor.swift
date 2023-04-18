//
//  WithdrawInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol WithdrawRouting: ViewableRouting {
    func bind(homeViewModel: HomeViewModel)
    func reloadData()
}

protocol WithdrawPresentable: Presentable {
    var listener: WithdrawPresentableListener? { get set }

    func bind(viewModel: CardViewModel)
    func bindWithdrawResult(isSuccess: Bool, message: String)
    func bind(homeViewModel: HomeViewModel)
}

protocol WithdrawListener: AnyObject {
    func withDrawWantToDismiss()
    func withDrawWantToRouteToAddCard()
}

final class WithdrawInteractor: PresentableInteractor<WithdrawPresentable>  {

    weak var router: WithdrawRouting?
    weak var listener: WithdrawListener?
    private var viewModel = CardViewModel.makeEmpty()
    private var homeViewModel: HomeViewModel?

    override init(presenter: WithdrawPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchAccounts()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchAccounts() {
        CardDatabase.shared.getListOfCards { listCards in
            self.viewModel = CardViewModel(listCards: listCards)
            self.presenter.bind(viewModel: self.viewModel)
        }
    }
}

// MARK: - WithdrawPresentableListener
extension WithdrawInteractor: WithdrawPresentableListener {
    func didTapBackButton() {
        self.listener?.withDrawWantToDismiss()
    }

    func routeToAddCard() {
        self.listener?.withDrawWantToRouteToAddCard()
    }

    func didTapWithdrawButton(card: Card, amount: Double) {
        SVProgressHUD.show()
        STPPaymentHelper.shared.handlePayment(card: card, price: amount, paymentType: .withdraw, completion: {[weak self] error in
            if let error = error {
                SVProgressHUD.dismiss()
                self?.presenter.bindWithdrawResult(isSuccess: false, message: error.localizedDescription)
            } else {
                AccountDatabase.shared.withdraw(amount: amount) { error in
                    SVProgressHUD.dismiss()
                    if let error = error {
                        self?.presenter.bindWithdrawResult(isSuccess: false, message: error.localizedDescription)
                    } else {
                        self?.presenter.bindWithdrawResult(isSuccess: true, message: "Your payment was handled successfully")
                    }
                }
            }
        })
    }
}

// MARK: - WithdrawInteractable
extension WithdrawInteractor: WithdrawInteractable {
    func reloadData() {
        self.fetchAccounts()
    }

    func bind(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.presenter.bind(homeViewModel: homeViewModel)
    }
}

