//
//  AudioPreviewInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 10/07/2023.
//

import RIBs
import RxSwift

protocol AudioPreviewRouting: ViewableRouting {
}

protocol AudioPreviewPresentable: Presentable {
    var listener: AudioPreviewPresentableListener? { get set }

    func bind(viewModel: AudioPreviewViewModel)
}

protocol AudioPreviewListener: AnyObject {
    func audioPreviewWantToDismiss()
    func audioPreviewWantToDelete()
    func audioPreviewWantToSendAudio(_ audioURL: URL)
}

final class AudioPreviewInteractor: PresentableInteractor<AudioPreviewPresentable>, AudioPreviewInteractable {

    weak var router: AudioPreviewRouting?
    weak var listener: AudioPreviewListener?
    var viewModel: AudioPreviewViewModel

    init(presenter: AudioPreviewPresentable, audioURL: URL) {
        self.viewModel = AudioPreviewViewModel(audioURL: audioURL)
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

// MARK: - AudioPreviewPresentableListener
extension AudioPreviewInteractor: AudioPreviewPresentableListener {
    func didTapCancel() {
        self.listener?.audioPreviewWantToDismiss()
    }

    func didTapDelete() {
        self.listener?.audioPreviewWantToDelete()
    }

    func didTapSend(audioURL: URL) {
        self.listener?.audioPreviewWantToSendAudio(audioURL)
    }
}
