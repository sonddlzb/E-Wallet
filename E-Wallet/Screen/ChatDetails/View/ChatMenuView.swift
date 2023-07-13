//
//  ChatMenuView.swift
//  E-Wallet
//
//  Created by đào sơn on 27/06/2023.
//

import UIKit

private struct Const {
    static let stackSpacing = 10.0
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 20.0, right: 20.0)
    static let cellSpacing = 10.0
}

protocol ChatMenuViewDelegate: AnyObject {
    func chatMenuView(_ chatMenuView: ChatMenuView, didSelectAt option: ChatMenuOption)
    func chatMenuViewDidTapCancel(_ chatMenuView: ChatMenuView)
    func chatMenuViewDidTapFinish(_ chatMenuView: ChatMenuView)
}

class ChatMenuView: UIView {
    @IBOutlet private weak var voiceRecordHUD: VoiceRecordHUD!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var recordContainerView: UIView!

    weak var delegate: ChatMenuViewDelegate?

    static func loadView() -> ChatMenuView {
        return ChatMenuView.loadView(fromNib: "ChatMenuView")!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    private func config() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: ChatMenuCell.self)
    }

    func update(_ rate: CGFloat) {
        self.voiceRecordHUD.update(rate)
    }

    func setFillColor(_ color: UIColor) {
        self.voiceRecordHUD.fillColor = color
    }

    func updateDuration(_ duration: Int) {
        // current speed 60 image/s
        self.durationLabel.text = (duration/60).timeString()
    }

    func showRecordView() {
        self.recordContainerView.isHidden = false
    }

    func hideRecordView() {
        self.recordContainerView.isHidden = true
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.delegate?.chatMenuViewDidTapCancel(self)
    }

    @IBAction func didTapFinish(_ sender: Any) {
        self.delegate?.chatMenuViewDidTapFinish(self)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ChatMenuView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChatMenuOption.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: ChatMenuCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: ChatMenuItemViewModel(option: ChatMenuOption.allCases[indexPath.row]))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.chatMenuView(self, didSelectAt: ChatMenuOption.allCases[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let total = ChatMenuOption.allCases.count
        let width = (self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right - CGFloat(total - 1) * Const.cellSpacing) / CGFloat(total)
        let height = self.collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
