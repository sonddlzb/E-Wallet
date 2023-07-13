//
//  Recording.swift
//  E-Wallet
//
//  Created by đào sơn on 09/07/2023.
//

import Foundation
import AVFoundation
import QuartzCore

@objc public protocol RecorderDelegate: AVAudioRecorderDelegate {
    @objc optional func audioMeterDidUpdate(_ dBValue: Float)
}

open class Recording: NSObject {

    @objc public enum State: Int {
        case none, record, play
    }

    static var directory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    open weak var delegate: RecorderDelegate?
    open fileprivate(set) var url: URL
    open fileprivate(set) var state: State = .none

    open var bitRate = 192000
    open var sampleRate = 44100.0
    open var channels = 1

    fileprivate let session = AVAudioSession.sharedInstance()
    var recorder: AVAudioRecorder?
    fileprivate var player: AVAudioPlayer?
    fileprivate var link: CADisplayLink?

    var metering: Bool {
        return delegate?.responds(to: #selector(RecorderDelegate.audioMeterDidUpdate(_:))) == true
    }

    // MARK: - Initializers

    public init(toValue: String) {
        url = URL(fileURLWithPath: Recording.directory).appendingPathComponent(toValue)
        super.init()
    }

    // MARK: - Record

    open func prepare() throws {
        let settings: [String: AnyObject] = [
            AVFormatIDKey: NSNumber(value: Int32(kAudioFormatAppleLossless) as Int32),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey: bitRate as AnyObject,
            AVNumberOfChannelsKey: channels as AnyObject,
            AVSampleRateKey: sampleRate as AnyObject
        ]

        recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder?.prepareToRecord()
        print("prepared to record")
        recorder?.delegate = delegate
        recorder?.isMeteringEnabled = metering
    }

    open func record() throws {
        if recorder == nil {
            try prepare()
        }

        try session.setCategory(AVAudioSession.Category.playAndRecord)
        try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        try session.setActive(true)

        print("recorder value \(recorder)")
        recorder?.record()
        state = .record

        if metering {
            startMetering()
        }
    }

    // MARK: - Playback

    open func play() throws {
        try session.setCategory(AVAudioSession.Category.playback)

        player = try AVAudioPlayer(contentsOf: url)
        player?.play()
        state = .play
    }

    open func stop(isCancel: Bool) {
        switch state {
        case .play:
            player?.stop()
            player = nil
        case .record:
            recorder?.stop()
            recorder = nil
            stopMetering()
            if isCancel {
                self.deleteRecorder()
            }

        default:
            break
        }

        state = .none
    }

    func deleteRecorder() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            print("recorder file deleted successfully.")
        } catch {
            print("Error deleting recorder file: \(error)")
        }
    }

    // MARK: - Metering

    @objc func updateMeter() {
        guard let recorder = recorder else { return }

        recorder.updateMeters()

        let dBValue = recorder.averagePower(forChannel: 0)

        delegate?.audioMeterDidUpdate?(dBValue)
    }

    fileprivate func startMetering() {
        link = CADisplayLink(target: self, selector: #selector(Recording.updateMeter))
        link?.add(to: RunLoop.current, forMode: .common)
    }

    fileprivate func stopMetering() {
        link?.invalidate()
        link = nil
    }
}
