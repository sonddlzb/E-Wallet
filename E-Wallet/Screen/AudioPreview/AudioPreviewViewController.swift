//
//  AudioPreviewViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 10/07/2023.
//

import RIBs
import RxSwift
import UIKit

protocol AudioPreviewPresentableListener: AnyObject {
    func didTapCancel()
    func didTapDelete()
    func didTapSend(audioURL: URL)
}

final class AudioPreviewViewController: UIViewController, AudioPreviewViewControllable {

    // MARK: - Outlet
    @IBOutlet private weak var audioPlayView: AudioPlayView!

    // MARK: - Variables
    weak var listener: AudioPreviewPresentableListener?
    var viewModel: AudioPreviewViewModel?

    // MARK: - Action
    @IBAction func didTapCancel(_ sender: Any) {
        self.listener?.didTapCancel()
    }
    @IBAction func didTapDelete(_ sender: Any) {
        self.listener?.didTapDelete()
    }

    @IBAction func didTapSend(_ sender: Any) {
        if let audioURL = self.viewModel?.audioURL {
            self.listener?.didTapSend(audioURL: audioURL)
        }
    }
}

// MARK: - AudioPreviewPresentable
extension AudioPreviewViewController: AudioPreviewPresentable {
    func bind(viewModel: AudioPreviewViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.audioPlayView.bind(audioURL: viewModel.audioURL)
    }
}
