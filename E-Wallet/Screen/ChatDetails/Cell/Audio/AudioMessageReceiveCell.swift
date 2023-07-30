//
//  AudioMessageReceiveCell.swift
//  E-Wallet
//
//  Created by đào sơn on 11/07/2023.
//

import UIKit

class AudioMessageReceiveCell: UICollectionViewCell {

    @IBOutlet weak var audioPlayerView: AudioPlayView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.audioPlayerView.layer.cornerRadius = 10.0
    }

    func bind(itemViewModel: ChatDetailsItemViewModel) {
        itemViewModel.downloadM4AFile { audioURL in
            if let audioURL = audioURL {
                DispatchQueue.main.async {
                    self.audioPlayerView.bind(audioURL: audioURL)
                }
            }
        }
    }
}
