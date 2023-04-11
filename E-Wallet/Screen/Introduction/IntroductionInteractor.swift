//
//  IntroductionInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs
import RxSwift

protocol IntroductionRouting: ViewableRouting {
}

protocol IntroductionPresentable: Presentable {
    var listener: IntroductionPresentableListener? { get set }

    func bind(viewModel: IntroductionViewModel)
}

protocol IntroductionListener: AnyObject {
    func introductionWantToRouteSignIn()
}

final class IntroductionInteractor: PresentableInteractor<IntroductionPresentable>, IntroductionInteractable {

    weak var router: IntroductionRouting?
    weak var listener: IntroductionListener?
    private var viewModel = IntroductionViewModel()

    override init(presenter: IntroductionPresentable) {
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

// MARK: - IntroductionPresentableListener
extension IntroductionInteractor: IntroductionPresentableListener {
    func didScrollTo(currentScrolledIndex: Int) {
        guard self.viewModel.currentPageIndex != currentScrolledIndex else {
            return
        }

        self.viewModel.currentPageIndex = currentScrolledIndex
        self.presenter.bind(viewModel: self.viewModel)
    }

    func didTapSkip() {
        self.viewModel.currentPageIndex = self.viewModel.numberOfSlides()-1
        self.presenter.bind(viewModel: self.viewModel)
    }

    func routeToSignIn() {
        self.listener?.introductionWantToRouteSignIn()
    }
}
