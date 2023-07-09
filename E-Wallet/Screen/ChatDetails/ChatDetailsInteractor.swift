//
//  ChatDetailsInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol ChatDetailsRouting: ViewableRouting {
    func openHistory(at transaction: Transaction)
    func dismissHistory()
    func routeToPhotoPreview(image: UIImage)
    func dismissPhotoPreview()
}

protocol ChatDetailsPresentable: Presentable {
    var listener: ChatDetailsPresentableListener? { get set }

    func bind(viewModel: ChatDetailsViewModel)
    func bindSentMessageFailedResult(message: String)
}

protocol ChatDetailsListener: AnyObject {
    func chatDetailsWantToDismiss()
    func chatDetailsWantToRouteToTransferMoney(phoneNumber: String)
}

final class ChatDetailsInteractor: PresentableInteractor<ChatDetailsPresentable>, ChatDetailsInteractable {

    weak var router: ChatDetailsRouting?
    weak var listener: ChatDetailsListener?
    var viewModel: ChatDetailsViewModel

    init(presenter: ChatDetailsPresentable, talker: User) {
        self.viewModel = ChatDetailsViewModel(talker: talker, listMessages: [])
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchMessageData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchMessageData() {
        MessageDatabase.shared.fetchAllMessagesBy(talker: viewModel.talker) { [weak self] listMessages in
            guard let self = self else {
                return
            }

            self.viewModel.listMessages = listMessages
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}

// MARK: - ChatDetailsPresentableListener
extension ChatDetailsInteractor: ChatDetailsPresentableListener {
    func didTapBackButton() {
        self.listener?.chatDetailsWantToDismiss()
    }

    func didTapToSendMessage(_ message: String) {
        MessageDatabase.shared.sendTextMessage(to: self.viewModel.talker.id, content: message, repliedId: "") { isSuccess in
            print("send message result : \(isSuccess ? "success" : "failed")")
            self.fetchMessageData()
        }
    }

    func openTransactionDetails(_ transactionId: String) {
        SVProgressHUD.show()
        TransactionDatabase.shared.fetchTransactionBy(id: transactionId) { [weak self] transaction in
            SVProgressHUD.dismiss()
            if let transaction = transaction {
                self?.router?.openHistory(at: transaction)
            }
        }
    }

    func didTapTransfer() {
        self.listener?.chatDetailsWantToRouteToTransferMoney(phoneNumber: self.viewModel.talker.phoneNumber)
    }

    func sendImage(image: UIImage) {
        MessageImageDatabase.shared.sendMessageImage(image, receiverId: self.viewModel.talker.id, repliedId: "") { error, isSuccess in
            if let error = error {
                self.presenter.bindSentMessageFailedResult(message: error.localizedDescription)
            } else {
                if !isSuccess {
                    self.presenter.bindSentMessageFailedResult(message: "Something went wrong. Try again later!")
                }
            }
        }
    }

    func openPhotoPreview(_ image: UIImage) {
        self.router?.routeToPhotoPreview(image: image)
    }
}
