//
//  HistoryInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import RIBs
import RxSwift

protocol HistoryRouting: ViewableRouting {
    func routeToTransactionDetails(transaction: Transaction, animated: Bool)
    func dismissTransactionDetails()
}

protocol HistoryPresentable: Presentable {
    var listener: HistoryPresentableListener? { get set }

    func bind(viewModel: HistoryViewModel)
    func stopLoadingEffect()
}

protocol HistoryListener: AnyObject {
}

final class HistoryInteractor: PresentableInteractor<HistoryPresentable>, HistoryInteractable {

    weak var router: HistoryRouting?
    weak var listener: HistoryListener?
    private var viewModel = HistoryViewModel.makeEmpty()

    override init(presenter: HistoryPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchTransactionsData(topic: "All")
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchTransactionsData(topic: String) {
        let previousViewModel = self.viewModel
        TransactionDatabase.shared.fetchTransactionsBy(topic) { listTransaction in
            self.viewModel = HistoryViewModel(listTransaction: listTransaction)
            if self.viewModel != previousViewModel {
                DispatchQueue.main.async {
                    self.presenter.bind(viewModel: self.viewModel)
                }
            } else {
                DispatchQueue.main.async {
                    self.presenter.bind(viewModel: self.viewModel)
                    self.presenter.stopLoadingEffect()
                }
            }
        }
    }
}

// MARK: - HistoryPresentableListener
extension HistoryInteractor: HistoryPresentableListener {
    func reloadDataIfNeed(topic: String) {
        self.fetchTransactionsData(topic: topic)
    }

    func fetchTransactionsByKey(_ key: String, currentTopic: String) {
        self.viewModel.filteredModal(by: key) { viewModel in
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: viewModel)
            }
        }
    }

    func didSelect(transaction: Transaction) {
        self.router?.routeToTransactionDetails(transaction: transaction, animated: true)
    }
}
