//
//  PasswordView.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import UIKit

private struct Const {
    static let cellSpacing = 20.0
    static let collectionViewLeftPadding = 80.0
    static let collectionViewRightPadding = 80.0
    static let cellPadding = 10.0
}

protocol PasswordViewDelegate: AnyObject {
    func passwordViewDidEnterPassword(_ passwordView: PasswordView, password: String)
}

class PasswordView: UIView {
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_lock")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Outfit.mediumFont(size: 18.0)
        label.text = "Enter your password"
        label.textColor = .crayola
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordIconView: PasswordIconView = {
        let view = PasswordIconView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(type: KeyCell.self)
        return collectionView
    }()

    private var listNumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "x"]
    weak var delegate: PasswordViewDelegate?
    var currentPassword = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }

    private func setUpView() {
        self.addContentViews()
        self.addLayoutConstraints()
    }

    private func addContentViews() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.symbolImageView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.passwordIconView)
        self.containerView.addSubview(self.collectionView)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()

        NSLayoutConstraint.activate([
            self.symbolImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.symbolImageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.symbolImageView.heightAnchor.constraint(equalToConstant: 50.0),
            self.symbolImageView.heightAnchor.constraint(equalTo: self.symbolImageView.widthAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.symbolImageView.bottomAnchor, constant: 20.0),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.passwordIconView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 30.0),
            self.passwordIconView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.passwordIconView.widthAnchor.constraint(equalToConstant: 135.0),
            self.passwordIconView.heightAnchor.constraint(equalToConstant: 16.0),

            self.collectionView.topAnchor.constraint(equalTo: self.passwordIconView.bottomAnchor, constant: 20.0),
            self.collectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Const.collectionViewLeftPadding),
            self.collectionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Const.collectionViewRightPadding),
            self.collectionView.heightAnchor.constraint(equalToConstant: 400.0)
        ])
    }

    func bind(title: String) {
        self.titleLabel.text = title
    }

    func reset() {
        self.currentPassword = ""
        self.passwordIconView.reset()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PasswordView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listNumbers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: KeyCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(number: self.listNumbers[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.listNumbers.count-1 {
            self.passwordIconView.delete(at: self.currentPassword.count-1)
            self.currentPassword = String(self.currentPassword.dropLast())
        } else if self.currentPassword.count < self.passwordIconView.numberOfIcons {
            self.passwordIconView.select(at: self.currentPassword.count)
            self.currentPassword += self.listNumbers[indexPath.row]
            if self.currentPassword.count == self.passwordIconView.numberOfIcons {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.delegate?.passwordViewDidEnterPassword(self, password: self.currentPassword)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PasswordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.width - 2 * Const.cellSpacing)/3
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellPadding
    }
}
