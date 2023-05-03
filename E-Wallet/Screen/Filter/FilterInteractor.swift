//
//  FilterInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import RIBs
import RxSwift

protocol FilterRouting: ViewableRouting {
}

protocol FilterPresentable: Presentable {
    var listener: FilterPresentableListener? { get set }
}

protocol FilterListener: AnyObject {
    func filterWantToDismiss()
    func filterWantToSave(filterModel: FilterModel)
    func filterWantToFilterHistory(filterModel: FilterModel)
}

final class FilterInteractor: PresentableInteractor<FilterPresentable>, FilterInteractable {

    weak var router: FilterRouting?
    weak var listener: FilterListener?

    override init(presenter: FilterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - FilterPresentableListener
extension FilterInteractor: FilterPresentableListener {
    func didTapCancel() {
        self.listener?.filterWantToDismiss()
    }

    func didUpdateFilterModel(filterModel: FilterModel) {
        self.listener?.filterWantToSave(filterModel: filterModel)
    }

    func didTapFilter(filterModel: FilterModel) {
        self.listener?.filterWantToFilterHistory(filterModel: filterModel)
    }
}
