//
//  ChatInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 11/06/2023.
//

import RIBs
import RxSwift

protocol ChatRouting: ViewableRouting {
}

protocol ChatPresentable: Presentable {
    var listener: ChatPresentableListener? { get set }

    func bind(viewModel: ChatViewModel)
}

protocol ChatListener: AnyObject {
}

final class ChatInteractor: PresentableInteractor<ChatPresentable>, ChatInteractable, ChatPresentableListener {

    weak var router: ChatRouting?
    weak var listener: ChatListener?
    var viewModel = ChatViewModel.makeEmpty()

    override init(presenter: ChatPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchRecentChatData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchRecentChatData() {
        var listRecentMessages: [Message] = []
        var listRecentUsers: [User] = []
        var listRecentUsersTemp: [User] = []
        MessageDatabase.shared.getListRecentMessages { recentMessagesDict in
            for (recentUser, recentMessage) in recentMessagesDict {
                listRecentMessages.append(recentMessage)
                listRecentUsersTemp.append(recentUser)
            }

            listRecentMessages = listRecentMessages.sorted {
                $0.sendTime > $1.sendTime
            }

            for (index, recentUser) in listRecentUsersTemp.enumerated() {
                if recentUser.id == listRecentMessages[index].senderId || recentUser.id == listRecentMessages[index].receiverId {
                    listRecentUsers.append(recentUser)
                }
            }

            self.viewModel = ChatViewModel(listNewestMessages: listRecentMessages, listTalkers: listRecentUsers)
            self.presenter.bind(viewModel: self.viewModel)
        }
    }
}
