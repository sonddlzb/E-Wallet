//
//  PaymentMethodView.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    static let cellPadding = 5.0
    static let cellHeight = 50.0
}

protocol PaymentMethodViewDelegate: AnyObject {
    func paymentMethodView(_ paymentMethodView: PaymentMethodView, didSelect card: Card?)
    func paymentMethodViewWantToShowAllCard(_ paymentMethodView: PaymentMethodView)
}

class PaymentMethodView: UIView {
    // MARK: - Outlets
    private var containerView: UIView!
    private var collectionView: UICollectionView!
    private var selectCardLabel: UILabel!
    private var selectCardButton: TapableView!
    private var imageView: UIImageView!

    // MARK: - Variables
    private var viewModel = CardViewModel.makeEmpty()
    private var balance = 0.0
    var selectedCard: Card? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    weak var delegate: PaymentMethodViewDelegate?

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
        self.addContentViews()
        self.addLayoutConstraints()
    }

    // MARK: - Config
    private func config() {
        self.configContainerView()
        self.configCollectionView()
        self.configSelectCardButton()
    }

    private func configContainerView() {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configSelectCardButton() {
        self.selectCardButton = TapableView()
        self.selectCardButton.translatesAutoresizingMaskIntoConstraints = false
        self.selectCardButton.addTarget(self, action: #selector(didTapSelectCard(_:)), for: .touchUpInside)

        self.imageView = UIImageView()
        self.imageView.image = UIImage(named: "ic_arrow_right")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false

        self.selectCardLabel = UILabel()
        self.selectCardLabel.text = "Select card"
        self.selectCardLabel.textColor = .crayola
        self.selectCardLabel.font = Outfit.semiBoldFont(size: 18.0)
        self.selectCardLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = Const.contentInset
        collectionView.registerCell(type: PaymentMethodCell.self)
    }

    private func addContentViews() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.collectionView)
        self.containerView.addSubview(self.selectCardButton)
        self.selectCardButton.addSubview(self.selectCardLabel)
        self.selectCardButton.addSubview(self.imageView)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 50.0),

            self.selectCardButton.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 20.0),
            self.selectCardButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.selectCardButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.selectCardButton.heightAnchor.constraint(equalToConstant: 30.0),

            self.selectCardLabel.leadingAnchor.constraint(equalTo: self.selectCardButton.leadingAnchor, constant: 20.0),
            self.selectCardLabel.topAnchor.constraint(equalTo: self.selectCardButton.topAnchor),
            self.selectCardLabel.bottomAnchor.constraint(equalTo: self.selectCardButton.bottomAnchor),

            self.imageView.centerYAnchor.constraint(equalTo: self.selectCardButton.centerYAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.selectCardButton.trailingAnchor, constant: -20.0),
            self.imageView.heightAnchor.constraint(equalToConstant: 16.0),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor)
        ])
    }

    func bind(viewModel: CardViewModel, balance: Double) {
        self.viewModel = viewModel
        self.balance = balance
        self.collectionView.reloadData()
    }

    func selectCard(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.selectedCard = nil
        } else {
            self.selectedCard = self.viewModel.listCards[indexPath.row-1]
        }

        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc func didTapSelectCard(_ sender: Any) {
        self.delegate?.paymentMethodViewWantToShowAllCard(self)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PaymentMethodView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfAccounts() + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: PaymentMethodCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        if indexPath.row == 0 {
            cell.bind(balance: self.balance, isSelected: self.selectedCard == nil, isFullVersion: false)
        } else {
            cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row - 1), isSelected: self.selectedCard?.id == self.viewModel.listCards[indexPath.row - 1].id, isFullVersion: false)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.selectedCard = nil
        } else {
            self.selectedCard = self.viewModel.listCards[indexPath.row - 1]
        }

        self.delegate?.paymentMethodView(self, didSelect: self.selectedCard)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PaymentMethodView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right - Const.cellPadding * 2)/5*2
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellPadding
    }
}
