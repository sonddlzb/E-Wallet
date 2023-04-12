//
//  ProfileViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let cellSpacing = 12.0
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 10.0)
}

protocol ProfilePresentableListener: AnyObject {
    func didTapSignOut()
}

final class ProfileViewController: UIViewController, ProfileViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Variables
    weak var listener: ProfilePresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.configCollectionView()
    }

    private func configCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: ProfileCell.self)
    }

    // MARK: - Actions
    @IBAction func didTapUserInforButton(_ sender: Any) {
        // show user information
    }

    @IBAction func didTapSignOutButton(_ sender: Any) {
        ConfirmDialog.shared.delegate = self
        ConfirmDialog.show(message: "Do you want to end this login session?")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileOption.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: ProfileCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(profileOption: ProfileOption.allCases[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = 60.0
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}

// MARK: - ConfirmDialogDelegate
extension ProfileViewController: ConfirmDialogDelegate {
    func confirmDialogDidTapConfirm(_ confirmDialog: ConfirmDialog) {
        self.listener?.didTapSignOut()
    }
}

// MARK: - ProfilePresentable
extension ProfileViewController: ProfilePresentable {
    func bindSignOutFailedResult(message: String) {
        FailedDialog.show(title: "Failed to sign out", message: message)
    }
}
