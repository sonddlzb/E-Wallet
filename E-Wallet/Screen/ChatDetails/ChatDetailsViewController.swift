//
//  ChatDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs
import RxSwift
import UIKit
import Photos

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    static let cellSpacing = 4.0
}

protocol ChatDetailsPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapToSendMessage(_ message: String)
    func openTransactionDetails(_ transactionId: String)
    func didTapTransfer()
    func sendImage(image: UIImage)
    func openPhotoPreview(_ image: UIImage)
}

final class ChatDetailsViewController: UIViewController, ChatDetailsViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var avtImageView: UIImageView!
    @IBOutlet private weak var messageTextField: SolarTextField!
    @IBOutlet private weak var sendButton: TapableView!
    @IBOutlet private weak var sendImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!

    private lazy var chatMenuView: ChatMenuView = {
        let view = ChatMenuView.loadView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Variables
    weak var listener: ChatDetailsPresentableListener?
    var viewModel: ChatDetailsViewModel?
    var keyboardHeight = 280.0
    var isChatMenuShowing = false
    private var imagePicker = UIImagePickerController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.imagePicker.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideChatMenu()
        self.bottomViewBottomConstraint.constant = 0.0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func config() {
        self.configMessageTextField()
        self.configCollectionView()

        self.view.addSubview(self.chatMenuView)
        NSLayoutConstraint.activate([
            self.chatMenuView.heightAnchor.constraint(equalToConstant: self.keyboardHeight),
            self.chatMenuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.chatMenuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.chatMenuView.topAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20.0)
        ])
        self.chatMenuView.alpha = 0.0
        self.chatMenuView.delegate = self
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: TextMessageSendCell.self)
        self.collectionView.registerCell(type: TextMessageReceiveCell.self)
        self.collectionView.registerCell(type: MoneyMessageSendCell.self)
        self.collectionView.registerCell(type: MoneyMessageReceiveCell.self)
        self.collectionView.registerCell(type: ImageMessageSendCell.self)
        self.collectionView.registerCell(type: ImageMessageReceiveCell.self)
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
        self.showChatMenu()
        if self.messageTextField.isEditing {
            self.messageTextField.resignFirstResponder()
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
                self.bottomViewBottomConstraint.constant = self.keyboardHeight - 30.0
                self.view.layoutIfNeeded()
            }
        }
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
            self.keyboardHeight = keyboardFrame.height
            self.chatMenuView.heightConstraint()?.constant = self.keyboardHeight
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.bottomViewBottomConstraint.constant = self.keyboardHeight - 30.0
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard !self.isChatMenuShowing else {
            return
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.bottomViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }

    func showChatMenu() {
        self.isChatMenuShowing = true
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.chatMenuView.alpha = 1.0
        }
    }

    func hideChatMenu() {
        self.isChatMenuShowing = false
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.chatMenuView.alpha = 0.0
        }
    }

    func openGallary() {
        PermissionHelper().requestPhotoPermission { granted, needOpenSetting in
            if granted {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else if needOpenSetting {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
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

    func bindSentMessageFailedResult(message: String) {
        let alertViewController = UIAlertController(title: "Send image failed", message: message, preferredStyle: .alert)
        self.present(alertViewController, animated: true)
    }
}

extension ChatDetailsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideChatMenu()
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.bottomViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
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

        case .image:
            if itemViewModel.message.status == .sent || itemViewModel.message.status == .sendAndSeen {
                guard let sendCell = self.collectionView.dequeueCell(type: ImageMessageSendCell.self, indexPath: indexPath) else {
                    return UICollectionViewCell()
                }

                sendCell.bind(itemViewModel: itemViewModel)
                sendCell.delegate = self
                return sendCell
            } else {
                guard let receiveCell = self.collectionView.dequeueCell(type: ImageMessageReceiveCell.self, indexPath: indexPath) else {
                    return UICollectionViewCell()
                }

                receiveCell.delegate = self
                receiveCell.bind(itemViewModel: itemViewModel)
                return receiveCell
            }

        case .requestMoney: print("not handle yet")
        case .video: print("not handle yet")
        case .sendMoney:
            if itemViewModel.message.status == .sent || itemViewModel.message.status == .sendAndSeen {
                guard let sendCell = self.collectionView.dequeueCell(type: MoneyMessageSendCell.self, indexPath: indexPath) else {
                    return UICollectionViewCell()
                }

                sendCell.bind(itemViewModel: itemViewModel)
                sendCell.delegate = self
                return sendCell
            } else {
                guard let receiveCell = self.collectionView.dequeueCell(type: MoneyMessageReceiveCell.self, indexPath: indexPath) else {
                    return UICollectionViewCell()
                }

                receiveCell.bind(itemViewModel: itemViewModel)
                receiveCell.delegate = self
                return receiveCell
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hideChatMenu()
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.bottomViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = self.viewModel?.item(at: indexPath.row).message.type else {
            return CGSize.zero
        }

        let cellWidth = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right - 8.0
        switch type {
        case .text:
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
        case .sendMoney: return CGSize(width: cellWidth, height: 180.0)
        case .video: return .zero
        case .requestMoney: return .zero
        case .image:
            if let imageWidth = self.viewModel?.item(at: indexPath.row).message.width, let imageHeight = self.viewModel?.item(at: indexPath.row).message.height {
                if imageHeight > imageWidth {
                    let cellHeight = min(cellWidth, cellWidth*imageHeight/imageWidth)
                    return CGSize(width: cellWidth, height: cellHeight)
                } else {
                    let cellHeight = min(cellWidth*0.5, cellWidth*imageHeight/imageWidth)
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            } else {
                let cellHeight = cellWidth*0.6
                return CGSize(width: cellWidth, height: cellHeight)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}

// MARK: - MoneyMessageSendCellDelegate
extension ChatDetailsViewController: MoneyMessageSendCellDelegate {
    func didTapToSeeSendDetails(transactionId: String) {
        self.listener?.openTransactionDetails(transactionId)
    }
}

// MARK: - MoneyMessageReceiveCellDelegate
extension ChatDetailsViewController: MoneyMessageReceiveCellDelegate {
    func didTapToSeeReceiveDetails(transactionId: String) {
        self.listener?.openTransactionDetails(transactionId)
    }
}

extension ChatDetailsViewController: ChatMenuViewDelegate {
    func chatMenuView(_ chatMenuView: ChatMenuView, didSelectAt option: ChatMenuOption) {
        switch option {
        case .transfer:
            self.listener?.didTapTransfer()
        case .request: print("not handle yet")
        case .photo:
            self.openGallary()
        case .voice: print("not handle yet")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ChatDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.listener?.sendImage(image: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ImageMessageSendCellDelegate, ImageMessageReceiveCellDelegate
extension ChatDetailsViewController: ImageMessageSendCellDelegate, ImageMessageReceiveCellDelegate {
    func imageMessageSendCell(_ imageMessageSendCell: ImageMessageSendCell, didSelect image: UIImage) {
        self.listener?.openPhotoPreview(image)
    }

    func imageMessageReceiveCell(_ imageMessageReceiveCell: ImageMessageReceiveCell, didSelect image: UIImage) {
        self.listener?.openPhotoPreview(image)
    }
}
