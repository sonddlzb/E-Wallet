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
    func openChatFor(talker: User)
}

final class ChatInteractor: PresentableInteractor<ChatPresentable>, ChatInteractable {

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
        MessageDatabase.shared.getListRecentMessages { recentMessagesDict in
            var listRecentMessages: [Message] = []
            var listRecentUsers: [User] = []
            var listRecentUsersTemp: [User] = []
            var listRecentUsersTempSorted: [User] = []
            DispatchQueue.main.async {
                for (recentUser, recentMessage) in recentMessagesDict {
                    listRecentMessages.append(recentMessage)
                    listRecentUsersTemp.append(recentUser)
                }

                listRecentMessages = listRecentMessages.sorted {
                    $0.sendTime > $1.sendTime
                }

                for message in listRecentMessages {
                    let index = listRecentUsersTemp.firstIndex {
                        $0.id == message.senderId || $0.id == message.receiverId
                    }

                    if let index = index {
                        listRecentUsersTempSorted.append(listRecentUsersTemp[index])
                    }
                }

                for (index, recentUser) in listRecentUsersTempSorted.enumerated() {
                    if recentUser.id == listRecentMessages[safe: index]?.senderId || recentUser.id == listRecentMessages[safe: index]?.receiverId {
                        listRecentUsers.append(recentUser)
                    }
                }

                self.viewModel = ChatViewModel(listNewestMessages: listRecentMessages, listTalkers: listRecentUsers)
                self.presenter.bind(viewModel: self.viewModel)
            }
        }
    }
}

// MARK: - ChatPresentableListener
extension ChatInteractor: ChatPresentableListener {
    func reloadData() {
        self.fetchRecentChatData()
    }

    func didSelectChatAt(index: Int) {
        self.listener?.openChatFor(talker: self.viewModel.talker(at: index))
    }

    func didEnterKeyword(_ keyword: String) {
        if keyword.isEmpty {
            self.presenter.bind(viewModel: self.viewModel)
        } else {
            var listTalkers: [User] = []
            var listMessages: [Message] = []
            for index in 0...self.viewModel.listNewestMessages.count-1 {
                if self.viewModel.listTalkers[index].fullName.lowercased().contains(keyword.lowercased()) {
                    listTalkers.append(self.viewModel.listTalkers[index])
                    listMessages.append(self.viewModel.listNewestMessages[index])
                }
            }

            self.presenter.bind(viewModel: ChatViewModel(listNewestMessages: listMessages, listTalkers: listTalkers))
        }
    }
}
