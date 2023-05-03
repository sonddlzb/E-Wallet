//
//  HistoryViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    static let cellHeight = 70.0
    static let cellSpacing = 6.0
}

protocol HistoryPresentableListener: AnyObject {
    func reloadDataIfNeed(topic: String)
    func fetchTransactionsByKey(_ key: String, currentTopic: String)
    func didSelect(transaction: Transaction)
    func didTapFilter()
    func dismissFilterMode()
}

final class HistoryViewController: UIViewController, HistoryViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var searchTextField: SolarTextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var filterCheckedImageView: UIImageView!
    @IBOutlet private weak var topicTabBarView: TopicTabBarView!

    // MARK: - Variables
    weak var listener: HistoryPresentableListener?
    private var viewModel = HistoryViewModel.makeEmpty()
    private var isLoading = false
    var currentTopic = "All"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listener?.reloadDataIfNeed(topic: self.currentTopic)
    }

    // MARK: - Config
    private func config() {
        self.configSearchTextField()
        self.configTopicTabBarView()
        self.configCollectionView()
    }

    private func configSearchTextField() {
        self.searchTextField.isLeftButtonEnable = true
        self.searchTextField.setLeftImage(image: UIImage(named: "ic_search"))
        self.searchTextField.paddingLeft = 40.0
        self.searchTextField.placeholder = "Search"
        self.searchTextField.isHighlightedWhenEditting = false
        self.searchTextField.borderColor = .crayola
        self.searchTextField.backgroundColor = UIColor(rgb: 0xF5F5F5)
        self.searchTextField.delegate = self
    }

    private func configTopicTabBarView() {
        self.topicTabBarView.delegate = self
        self.topicTabBarView.datasource = self
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        self.collectionView.registerCell(type: HistoryCell.self)
    }

    // MARK: - Actions
    @objc func refreshCollectionView() {
        self.listener?.reloadDataIfNeed(topic: self.currentTopic)
    }

    @IBAction func didTapFilterButton(_ sender: Any) {
        self.listener?.didTapFilter()
    }
}

// MARK: - SolarTextFieldDelegate
extension HistoryViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        guard !text.isEmpty else {
            self.listener?.reloadDataIfNeed(topic: self.currentTopic)
            return true
        }

        self.listener?.fetchTransactionsByKey(text.lowercased(), currentTopic: self.currentTopic)
        return true
    }
}

extension HistoryViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: - TopicTabBarViewDelegate, TopicTabBarViewDatasource
extension HistoryViewController: TopicTabBarViewDelegate, TopicTabBarViewDatasource {
    func topicTabBarView(_ topicTabBarView: TopicTabBarView, didSelect topic: String) {
        self.currentTopic = topic
        self.listener?.dismissFilterMode()
        self.listener?.reloadDataIfNeed(topic: self.currentTopic)
        self.view.endEditing(true)
    }

    func listTopics(for topicTabBarView: TopicTabBarView) -> [String] {
        var listTopic: [String] = ["All"]
        listTopic.append(contentsOf: PaymentType.allCases.map {
            $0.rawValue
        })
        return listTopic
    }
}

// MARK: - HistoryPresentable
extension HistoryViewController: HistoryPresentable {
    func bind(viewModel: HistoryViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
    }

    func stopLoadingEffect() {
        self.collectionView.refreshControl?.endRefreshing()
    }

    func bindFilterState(isInFilterMode: Bool) {
        self.filterCheckedImageView.isHidden = !isInFilterMode
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfTransactions()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: HistoryCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.listener?.didSelect(transaction: self.viewModel.transaction(at: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}
