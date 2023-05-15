//
//  MyQRInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs
import RxSwift

protocol MyQRRouting: ViewableRouting {
}

protocol MyQRPresentable: Presentable {
    var listener: MyQRPresentableListener? { get set }

    func bind(viewModel: MyQRViewModel)
}

protocol MyQRListener: AnyObject {
}

final class MyQRInteractor: PresentableInteractor<MyQRPresentable>, MyQRInteractable, MyQRPresentableListener {

    weak var router: MyQRRouting?
    weak var listener: MyQRListener?
    var viewModel: MyQRViewModel!

    override init(presenter: MyQRPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchUserData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchUserData() {
        UserDatabase.shared.getUserInfor { user in
            if let userEntity = user {
                self.viewModel = MyQRViewModel(userEntity: userEntity)
                DispatchQueue.main.async {
                    self.presenter.bind(viewModel: self.viewModel)
                }
            }
        }
    }
}
