//
//  GiftApplyViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 09/05/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
    static let cellHeight = 70.0
    static let cellSpacing = 8.0
}

protocol GiftApplyPresentableListener: AnyObject {
    func didTapBackButton()
    func shouldApply(voucher: Voucher)
    func tapToSeeDetails(voucher: Voucher)
}

final class GiftApplyViewController: UIViewController, GiftApplyViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var discountTextField: SolarTextField!
    @IBOutlet private weak var applyLabel: UILabel!
    @IBOutlet private weak var applyButton: TapableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!

    private lazy var giftNoVouchersView: UIView = {
        let view = UIView.loadView(fromNib: "GiftNoVouchersView")!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Variables
    weak var listener: GiftApplyPresentableListener?
    var viewModel = GiftApplyViewModel.makeEmpty()
    var selectedVoucher: Voucher?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configDiscountTextField()
        self.configCollectionView()
        self.disableApplyButton()
    }

    private func configDiscountTextField() {
        discountTextField.placeholder = "You have other discount codes?"
        discountTextField.isHighlightedWhenEditting = false
        discountTextField.backgroundColor = UIColor(rgb: 0xF1F2F1)
        discountTextField.borderColor = .crayola
        discountTextField.textField.paddingLeft = 10
        discountTextField.cornerRadius = 8
        discountTextField.delegate = self
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: GiftApplyCell.self)
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func didTapApplyButton(_ sender: Any) {
        guard let selectedVoucher = self.selectedVoucher else {
            return
        }

        self.listener?.shouldApply(voucher: selectedVoucher)
    }

    // MARK: - Helpers
    func enableApplyButton() {
        self.applyButton.isUserInteractionEnabled = true
        self.applyLabel.backgroundColor = .crayola
    }

    func disableApplyButton() {
        self.applyButton.isUserInteractionEnabled = false
        self.applyLabel.backgroundColor = .lightGray
    }
}

// MARK: - SolarTextFieldDelegate
extension GiftApplyViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }
}

// MARK: - GiftApplyPresentable
extension GiftApplyViewController: GiftApplyPresentable {
    func bind(viewModel: GiftApplyViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        if self.viewModel.isEmpty() {
            self.containerView.addSubview(self.giftNoVouchersView)
            self.giftNoVouchersView.fitSuperviewConstraint()
        } else {
            self.giftNoVouchersView.removeFromSuperview()
        }

        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GiftApplyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfVouchers()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: GiftApplyCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        let itemViewModel = self.viewModel.item(at: indexPath.row)
        cell.bind(itemViewModel: itemViewModel, isSelected: self.selectedVoucher == itemViewModel.voucher)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedVoucher = self.viewModel.voucher(at: indexPath.row)
        self.enableApplyButton()
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GiftApplyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}

// MARK: - GiftApplyCellDelegate
extension GiftApplyViewController: GiftApplyCellDelegate {
    func giftApplyCell(_ giftApplyCell: GiftApplyCell, didSelectDetailsAt voucher: Voucher) {
        self.listener?.tapToSeeDetails(voucher: voucher)
    }
}
