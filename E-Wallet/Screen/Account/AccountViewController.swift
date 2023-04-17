//
//  AccountViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    static let cellSpacing = 10.0
    static let cellHeight = 70.0
}

protocol AccountPresentableListener: AnyObject {
    func routeToAddCard()
    func didSelectCard(_ card: Card)
}

final class AccountViewController: UIViewController, AccountViewControllable {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Variables
    weak var listener: AccountPresentableListener?
    private var viewModel = AccountViewModel.makeEmpty()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.configCollectionView()
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: AccountCell.self)
    }

    @IBAction func didTapAddCardButton(_ sender: Any) {
        self.listener?.routeToAddCard()
    }
}

// MARK: - AccountPresentable
extension AccountViewController: AccountPresentable {
    func bind(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfAccounts()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: AccountCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.listener?.didSelectCard(self.viewModel.listCards[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }
}
