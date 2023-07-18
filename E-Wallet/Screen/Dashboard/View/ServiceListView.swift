//
//  ServiceListView.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import UIKit

private struct Const {
    static let cellPadding = 16.0
}

protocol ServiceListViewDelegate: AnyObject {
    func serviceListView(_ serviceListView: ServiceListView, didSelectAt serviceType: ServiceType)
}

class ServiceListView: UIView {
    private var containerView: UIView!
    private var collectionView: UICollectionView!
    weak var delegate: ServiceListViewDelegate?
    var viewModel = ServiceViewModel.makeFull()

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
        self.addContentView()
        self.addLayoutConstraints()
    }

    private func config() {
        self.configContainerView()
        self.configCollectionView()
    }

    private func configContainerView() {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(type: ServiceCell.self)
    }

    private func addContentView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.collectionView)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.collectionView.fitSuperviewConstraint()
    }

    func bind(viewModel: ServiceViewModel) {
        self.viewModel = viewModel
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ServiceListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfServices()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: ServiceCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(serviceType: self.viewModel.service(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.serviceListView(self, didSelectAt: self.viewModel.service(at: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ServiceListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.width - 3*Const.cellPadding)/4
        let height = 110.0
        return CGSize(width: width, height: height)
    }
}
