//
//  IntroductionViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
}

protocol IntroductionPresentableListener: AnyObject {
    func didScrollTo(currentScrolledIndex: Int)
    func didTapSkip()
    func routeToSignIn()
}

final class IntroductionViewController: UIViewController, IntroductionViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var getStartedButton: TapableView!
    @IBOutlet private weak var pageSlideBar: PageSlideBar!

    // MARK: - Variables
    weak var listener: IntroductionPresentableListener?
    private var viewModel: IntroductionViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func config() {
        self.configPageSlideBar()
        self.configCollectionView()
    }

    private func configPageSlideBar() {
        pageSlideBar.numberOfPages = 3
        pageSlideBar.currentPage = 0
        pageSlideBar.mainColor = .crayola
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.dataSource = self
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.delegate = self
        self.collectionView.registerCell(type: SlideCell.self)
    }

    // MARK: - Actions
    @IBAction func getStartedButtonDidTap(_ sender: Any) {
        self.listener?.routeToSignIn()
    }

    // MARK: - Helpers
    private func getCurrentPageIndexFromScrollView() -> Int {
        return min(self.viewModel.numberOfSlides() - 1,
                   Int(((self.collectionView.contentOffset.x) / UIScreen.main.bounds.width).rounded()))
    }
}

// MARK: - IntroductionPresentable
extension IntroductionViewController: IntroductionPresentable {
    func bind(viewModel: IntroductionViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.getStartedButton.isHidden = self.viewModel.currentPageIndex != self.viewModel.numberOfSlides()-1
        self.collectionView.reloadData()
        self.pageSlideBar.currentPage = self.viewModel.currentPageIndex
        self.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.currentPageIndex, section: 0),
                                         at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension IntroductionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfSlides()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: SlideCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IntroductionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = self.collectionView.frame.height - Const.contentInset.top - Const.contentInset.bottom
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - SlideCellDelegate
extension IntroductionViewController: SlideCellDelegate {
    func slideCellDidTapSkip(_ slideCell: SlideCell) {
        self.listener?.didTapSkip()
    }
}

// MARK: - UIScrollViewDelegate
extension IntroductionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentScrolledIndex = self.getCurrentPageIndexFromScrollView()
        self.listener?.didScrollTo(currentScrolledIndex: currentScrolledIndex)
    }
}
