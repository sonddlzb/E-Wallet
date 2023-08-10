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
    func routeToFilter(filterModel: FilterModel?)
    func dismissFilter()
}

protocol HistoryPresentable: Presentable {
    var listener: HistoryPresentableListener? { get set }

    func bind(viewModel: HistoryViewModel)
    func stopLoadingEffect()
    func bindFilterState(isInFilterMode: Bool)
}

protocol HistoryListener: AnyObject {
}

final class HistoryInteractor: PresentableInteractor<HistoryPresentable>, HistoryInteractable {

    weak var router: HistoryRouting?
    weak var listener: HistoryListener?
    var viewModel = HistoryViewModel.makeEmpty()
    var previousFilterModel: FilterModel?
    var currentTopic = ""
    var isInFilterMode = false {
        didSet {
            self.presenter.bindFilterState(isInFilterMode: isInFilterMode)
        }
    }

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
        guard !self.isInFilterMode else {
            return
        }

        self.currentTopic = topic
        self.fetchTransactionsData(topic: topic)
    }

    func fetchTransactionsByKey(_ key: String, currentTopic: String) {
        self.viewModel.filteredModal(by: key) { viewModel in
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: viewModel)
            }
        }
    }

    func dismissFilterMode() {
        self.isInFilterMode = false
    }

    func didSelect(transaction: Transaction) {
        self.router?.routeToTransactionDetails(transaction: transaction, animated: true)
    }

    func didTapFilter() {
        if isInFilterMode {
            self.isInFilterMode = false
            self.reloadDataIfNeed(topic: self.currentTopic)
        } else {
            self.router?.routeToFilter(filterModel: self.previousFilterModel)
        }
    }
}
