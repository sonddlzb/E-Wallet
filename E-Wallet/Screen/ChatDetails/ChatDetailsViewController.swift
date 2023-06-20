//
//  ChatDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    static let cellSpacing = 4.0
}

protocol ChatDetailsPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapToSendMessage(_ message: String)
}

final class ChatDetailsViewController: UIViewController, ChatDetailsViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var avtImageView: UIImageView!
    @IBOutlet private weak var messageTextField: SolarTextField!
    @IBOutlet private weak var sendButton: TapableView!
    @IBOutlet private weak var sendImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Variables
    weak var listener: ChatDetailsPresentableListener?
    var viewModel: ChatDetailsViewModel?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func config() {
        self.configMessageTextField()
        self.configCollectionView()
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: TextMessageSendCell.self)
        self.collectionView.registerCell(type: TextMessageReceiveCell.self)
        self.collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    private func configMessageTextField() {
        self.messageTextField.paddingLeft = 10.0
        self.messageTextField.placeholder = "Enter your message"
        self.messageTextField.isHighlightedWhenEditting = false
        self.messageTextField.borderColor = .crayola
        self.messageTextField.backgroundColor = UIColor(rgb: 0xF5F5F5)
        self.messageTextField.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func didTapMoreOptionsButton(_ sender: Any) {
    }

    @IBAction func didTapSendButton(_ sender: Any) {
        let message = self.messageTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else {
            return
        }

        self.listener?.didTapToSendMessage(message)
        self.messageTextField.text = ""
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.bottomViewBottomConstraint.constant = keyboardHeight - 30.0
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.bottomViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ChatDetailsPresentable
extension ChatDetailsViewController: ChatDetailsPresentable {
    func bind(viewModel: ChatDetailsViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.avtImageView.setImage(with: viewModel.imageURL(), indicator: .activity)
        self.nameLabel.text = viewModel.name()
        self.collectionView.reloadData()
    }
}

extension ChatDetailsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - SolarTextFieldDelegate
extension ChatDetailsViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        let message = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.isEmpty {
            self.sendButton.isUserInteractionEnabled = false
            self.sendImageView.image = UIImage(named: "ic_send_not_able")
        } else {
            self.sendButton.isUserInteractionEnabled = true
            self.sendImageView.image = UIImage(named: "ic_send_able")
        }

        return true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ChatDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfMessages() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemViewModel = self.viewModel?.item(at: indexPath.row) else {
            return UICollectionViewCell()
        }

        let cell = UICollectionViewCell()
        switch itemViewModel.message.type {
        case .text:
            if itemViewModel.message.status == .sent || itemViewModel.message.status == .sendAndSeen {
                guard let sendCell = self.collectionView.dequeueCell(type: TextMessageSendCell.self, indexPath: indexPath) else {
                    return UICollectionViewCell()
                }

                sendCell.bind(itemViewModel: itemViewModel)
                return sendCell
            } else {
                guard let receiveCell = self.collectionView.dequeueCell(type: TextMessageReceiveCell.self, indexPath: indexPath) else {
                    return UICollectionViewCell()
                }

                receiveCell.bind(itemViewModel: itemViewModel)
                return receiveCell
            }

        case .image: print("not handle yet")
        case .requestMoney: print("not handle yet")
        case .video: print("not handle yet")
        case .sendMoney: print("not handle yet")
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right - 8.0
        var cellHeight = 0.0
        let content = self.viewModel?.content(at: indexPath.row) ?? ""
        let font = Outfit.regularFont(size: 20.0)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (content.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).size(withAttributes: attributes)
        if size.width <= cellWidth * 0.7 {
            cellHeight = size.height + 24.0
        } else {
            let numberOfLines: Int = Int((size.width/(cellWidth*0.7)) + 1)
            cellHeight = size.height * CGFloat(numberOfLines) + CGFloat(numberOfLines+1) * 7.0 + 8.0
        }

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}
