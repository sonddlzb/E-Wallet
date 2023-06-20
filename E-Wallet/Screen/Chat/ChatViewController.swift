//
//  ChatViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 11/06/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 0.0, right: 15.0)
    static let cellHeight = 70.0
}

protocol ChatPresentableListener: AnyObject {
    func reloadData()
    func didSelectChatAt(index: Int)
}

final class ChatViewController: UIViewController, ChatViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var searchTextField: SolarTextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var avatarImageView: UIImageView!

    // MARK: - Variables
    weak var listener: ChatPresentableListener?
    var viewModel = ChatViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listener?.reloadData()
    }

    private func config() {
        self.configCollectionView()
        self.configSearchTextField()
    }

    private func configSearchTextField() {
        self.searchTextField.isLeftButtonEnable = true
        self.searchTextField.setLeftImage(image: UIImage(named: "ic_search"))
        self.searchTextField.paddingLeft = 40.0
        self.searchTextField.placeholder = "Search"
        self.searchTextField.isHighlightedWhenEditting = false
        self.searchTextField.borderColor = .crayola
        self.searchTextField.backgroundColor = UIColor(rgb: 0xF5F5F5)
//        self.searchTextField.delegate = self
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: ChatCell.self)
    }
}

// MARK: - ChatPresentable
extension ChatViewController: ChatPresentable {
    func bind(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.collectionView.reloadData()
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfTalkers()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: ChatCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.listener?.didSelectChatAt(index: indexPath.row)
    }
}

extension ChatViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
