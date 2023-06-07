//
//  NotificationsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 30/05/2023.
//

import RIBs
import RxSwift

protocol NotificationsRouting: ViewableRouting {
    func openHistory(at transaction: Transaction)
    func dismissHistory()
}

protocol NotificationsPresentable: Presentable {
    var listener: NotificationsPresentableListener? { get set }

    func bind(viewModel: NotificationsViewModel)
}

protocol NotificationsListener: AnyObject {
    func notificationsWantToDismiss()
}

final class NotificationsInteractor: PresentableInteractor<NotificationsPresentable>, NotificationsInteractable {

    weak var router: NotificationsRouting?
    weak var listener: NotificationsListener?
    var viewModel = NotificationsViewModel.makeEmpty()

    override init(presenter: NotificationsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchNotifications()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchNotifications() {
        NotificationDatabase.shared.fetchAllNotification { listNotifications in
            self.viewModel = NotificationsViewModel(listNotifications: listNotifications)
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}

// MARK: - NotificationsPresentableListener
extension NotificationsInteractor: NotificationsPresentableListener {
    func didTapBack() {
        self.listener?.notificationsWantToDismiss()
    }

    func didSelectNotificationAt(index: Int) {
        let transactionId = self.viewModel.item(at: index).notificationMessage.transactionId
        TransactionDatabase.shared.fetchTransactionBy(id: transactionId) { transaction in
            if let transaction = transaction {
                self.router?.openHistory(at: transaction)
            }
        }
    }
}
