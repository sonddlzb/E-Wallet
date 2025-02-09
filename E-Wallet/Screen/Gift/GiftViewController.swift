//
//  GiftViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    static let cellSpacing = 12.0
    static let cellHeight = 80.0
}

protocol GiftPresentableListener: AnyObject {
    func reloadDataIfNeed()
    func didSelect(voucher: Voucher)
    func didTapUseNow(itemViewModel: GiftItemViewModel)
}

final class GiftViewController: UIViewController, GiftViewControllable {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Variables
    weak var listener: GiftPresentableListener?
    var viewModel = GiftViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: VoucherCell.self)
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }

    // MARK: - Actions
    @objc func refreshCollectionView() {
        self.listener?.reloadDataIfNeed()
    }
}

// MARK: - GiftPresentable
extension GiftViewController: GiftPresentable {
    func bind(viewModel: GiftViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.collectionView.reloadData()
    }

    func stopLoadingEffect() {
        self.collectionView.refreshControl?.endRefreshing()
    }

    func bindNotReadyState(at voucher: Voucher) {
        NotificationDialogView.loadView().show(in: self.view, title: "Your voucher is not ready!",
                                               message: "From \(voucher.openTime.formatDate()) you can use this voucher to receiver discount from E-Wallet. Please come back later.",
                                               image: UIImage(named: "ic_waiting"),
                                               color: .crayola)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GiftViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfVouchers()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: VoucherCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.listener?.didSelect(voucher: self.viewModel.listVouchers[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GiftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}

// MARK: - VoucherCellDelegate
extension GiftViewController: VoucherCellDelegate {
    func voucherCellDidTapUseNow(_ voucherCell: VoucherCell, itemViewModel: GiftItemViewModel) {
        self.listener?.didTapUseNow(itemViewModel: itemViewModel)
    }
}
