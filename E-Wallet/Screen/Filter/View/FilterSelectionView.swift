//
//  FilterSelectionView.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import UIKit

protocol FilterSelectionViewDelegate: AnyObject {
    func filterSelectionView(_ filterSelectionView: FilterSelectionView,
                             didSelect filterValue: String)
}

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
    static let cellPadding = 4.0
    static let cellSpacing = 4.0
    static let cellHeight = 50.0
    static let cellImageHeight = 90.0
}

class FilterSelectionView: UIView {
    // MARK: - Variables
    private var containerView: UIView!
    private var collectionView: UICollectionView!
    var numberOfColumns = 3 {
        didSet {
            self.collectionView.reloadData()
        }
    }

    var isImageVisible = false {
        didSet {
            self.collectionView.registerCell(type: self.isImageVisible ? SelectionImageCell.self : SelectionCell.self)
            self.collectionView.reloadData()
        }
    }

    var viewModel = FilterSelectionViewModel.makeEmpty()
    var selectedChoice = ""
    weak var delegate: FilterSelectionViewDelegate?

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
        self.addContentView()
        self.addLayoutConstraints()
    }

    // MARK: - Config
    private func config() {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = Const.contentInset
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(type: self.isImageVisible ? SelectionImageCell.self : SelectionCell.self)
    }

    private func addContentView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.collectionView)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.collectionView.fitSuperviewConstraint()
    }

    func bind(viewModel: FilterSelectionViewModel) {
        self.viewModel = viewModel
        self.selectedChoice = viewModel.selectedSelection ?? ""
        if self.selectedChoice.isEmpty {
            self.selectedChoice = viewModel.selection(at: 0)
        }

        self.collectionView.reloadData()
    }

    func clear() {
        if !self.selectedChoice.isEmpty, !self.viewModel.listSelections.isEmpty {
            self.selectedChoice = self.viewModel.selection(at: 0)
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilterSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfSelections()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isImageVisible {
            guard let cell = self.collectionView.dequeueCell(type: SelectionImageCell.self, indexPath: indexPath) else {
                return UICollectionViewCell()
            }

            cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row),
                      isSelect: self.selectedChoice.lowercased() == self.viewModel.selection(at: indexPath.row).lowercased())
            return cell
        } else {
            guard let cell = self.collectionView.dequeueCell(type: SelectionCell.self, indexPath: indexPath) else {
                return UICollectionViewCell()
            }

            cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row),
                      isSelect: self.selectedChoice.lowercased() == self.viewModel.selection(at: indexPath.row).lowercased())
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedChoice = self.viewModel.selection(at: indexPath.row)
        self.delegate?.filterSelectionView(self, didSelect: self.selectedChoice)
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right - Const.cellPadding * Double(self.numberOfColumns-1))/Double(self.numberOfColumns)
        let height = self.isImageVisible ? Const.cellImageHeight : Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellPadding
    }
}
