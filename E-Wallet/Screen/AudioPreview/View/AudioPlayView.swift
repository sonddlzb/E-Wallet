//
//  AudioPlayView.swift
//  E-Wallet
//
//  Created by đào sơn on 10/07/2023.
//

import UIKit
import RangeSeekSlider
import AVFoundation

class AudioPlayView: UIView {

    // MARK: - Variables
    private var containerView: UIView!
    private var playImageView: UIImageView!
    private var playButton: TapableView!
    private var slider: SeekBarView!
    private var timeLabel: UILabel!
    private var player: AVAudioPlayer?

    private var url: URL?
    private let session = AVAudioSession.sharedInstance()
    private var timer = Timer()
    var isPlaying = false {
        didSet {
            if isPlaying {
                self.play()
            } else {
                self.pause()
            }
        }
    }

    var currentTime = 0.0
    var isPlayingBefore = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.config()
        self.addContentView()
        self.addLayoutConstraints()
        self.layoutIfNeeded()
    }

    // MARK: - Config
    private func config() {
        self.containerView = UIView()
        self.backgroundColor = .lightGray
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        self.playImageView = UIImageView()
        self.playImageView.translatesAutoresizingMaskIntoConstraints = false
        self.playImageView.image = UIImage(named: "ic_play")

        self.playButton = TapableView()
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.addTarget(self, action: #selector(didTapPlayButton(_:)), for: .touchUpInside)

        self.slider = SeekBarView()
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.slider.delegate = self

        self.timeLabel = UILabel()
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.text = "00:00"
        self.timeLabel.textAlignment = .center
        self.timeLabel.font = Outfit.regularFont(size: 16.0)
    }

    // MARK: - Add content views
    private func addContentView() {
        self.addSubview(containerView)
        self.containerView.addSubview(self.playButton)
        self.playButton.addSubview(self.playImageView)
        self.containerView.addSubview(self.slider)
        self.containerView.addSubview(self.timeLabel)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.playImageView.fitSuperviewConstraint()

        NSLayoutConstraint.activate([
            self.playButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10.0),
            self.playButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10.0),
            self.playButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10.0),
            self.playButton.heightAnchor.constraint(equalTo: self.playImageView.widthAnchor),

            self.slider.leadingAnchor.constraint(equalTo: self.playImageView.trailingAnchor, constant: 10.0),
            self.slider.heightAnchor.constraint(equalToConstant: 24.0),
            self.slider.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.slider.trailingAnchor.constraint(equalTo: self.timeLabel.leadingAnchor),

            self.timeLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.timeLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10.0),
            self.timeLabel.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 12.0
    }

    @objc func didTapPlayButton(_ sender: Any) {
        self.isPlaying = !self.isPlaying
    }

    func play() {
        self.playImageView.image = UIImage(named: "ic_pause")
        player?.play()
        startTimerForAudio()
    }

    func pause() {
        self.playImageView.image = UIImage(named: "ic_play")
        player?.pause()
        self.stopTimerForAudio()
    }

    func bind(audioURL: URL) {
        self.url = audioURL
        try? session.setCategory(AVAudioSession.Category.playback)
        self.player = try? AVAudioPlayer(contentsOf: audioURL)
        self.timeLabel.text = Int(self.player?.duration ?? 0).timeString()
        self.player?.delegate = self
    }

    func startTimerForAudio() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }

            if let time = self.player?.currentTime {
                self.currentTime = time
                self.updateTimer()
            }
        })
    }

    func stopTimerForAudio() {
        self.timer.invalidate()
    }

    func updateTimer() {
        guard let duration = self.player?.duration else {
            return
        }

        print(self.currentTime)
        self.timeLabel.text = Int(self.currentTime).timeString()
        self.slider.updateSeekBarWith(currentTimeProgress: Double(self.currentTime)/duration)
    }
}

// MARK: - RangeSeekSliderDelegate
extension AudioPlayView: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {

    }
}

// MARK: SeekBarViewDelegate
extension AudioPlayView: SeekBarViewDelegate {
    func seekBarViewDidBeganSeek(_ view: SeekBarView) {
        if self.isPlaying {
            self.isPlayingBefore = true
        } else {
            self.isPlayingBefore = false
        }

        self.isPlaying = false
    }

    func seekBarViewDidEndedSeek(_ view: SeekBarView) {
        if self.isPlayingBefore {
            self.isPlaying = true
        } else {
            self.isPlaying = false
        }
    }

    func seekBarView(_ view: SeekBarView, seekTimeProgress progress: Double) {
        if let duration = self.player?.duration {
            let currentTime = duration * progress
            self.timeLabel.text = Int(currentTime).timeString()
            self.player?.currentTime = currentTime
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.slider.updateSeekBarWith(currentTimeProgress: 0.0)
    }
}
