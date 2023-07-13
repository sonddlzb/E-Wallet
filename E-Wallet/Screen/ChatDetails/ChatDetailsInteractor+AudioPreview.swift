//
//  ChatDetailsInteractor+AudioPreview.swift
//  E-Wallet
//
//  Created by đào sơn on 10/07/2023.
//

import Foundation

extension ChatDetailsInteractor: AudioPreviewListener {
    func audioPreviewWantToDismiss() {
        self.router?.dismissAudioPreview()
    }

    func audioPreviewWantToDelete() {
        self.presenter.deleteRecorder()
        self.router?.dismissAudioPreview()
    }

    func audioPreviewWantToSendAudio(_ audioURL: URL) {
        self.router?.dismissAudioPreview()
        self.presenter.hideChatMenuView()
        MessageAudioDatabase.shared.sendAudio(audioURL, receiverId: self.viewModel.talker.id, repliedId: "") { error, isSuccess in
            guard error == nil else {
                self.presenter.bindSentMessageFailedResult(message: error!.localizedDescription)
                return
            }

            guard isSuccess else {
                self.presenter.bindSentMessageFailedResult(message: "Something went wrong. Try again later!")
                return
            }

            self.presenter.deleteRecorder()
        }
    }
}
