//
//  TopicTabBarView.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import UIKit

private struct TopicTabBarViewConst {
    static var cellSpacing = 8.0
    static var cellPadding = 24.0
}

protocol TopicTabBarViewDelegate: AnyObject {
    func topicTabBarView(_ topicTabBarView: TopicTabBarView, didSelect topic: String)
}

protocol TopicTabBarViewDatasource: AnyObject {
    func listTopics(for topicTabBarView: TopicTabBarView) -> [String]
}

class TopicTabBarView: UIView {

    // MARK: - Variables
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 16.0)
        layout.scrollDirection = .horizontal

        return UICollectionView(frame: self.frame, collectionViewLayout: layout)
    }()

    weak var delegate: TopicTabBarViewDelegate?
    weak var datasource: TopicTabBarViewDatasource?
    var selectedTopic = "" {
        didSet {
            self.reloadData()
        }
    }

    var fontSize: Int = 18 {
        didSet {
            self.collectionView.reloadData()
        }
    }

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
    }

    // MARK: - Config
    private func config() {
        self.backgroundColor = UIColor(rgb: 0xFFF9F0)
        self.configCollectionView()
    }

    private func configCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.fitSuperviewConstraint()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: TopicTabBarViewCell.self)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
    }

    func reloadData() {
        if let index = self.datasource?.listTopics(for: self).firstIndex(of: selectedTopic) {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TopicTabBarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource?.listTopics(for: self).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueCell(type: TopicTabBarViewCell.self, indexPath: indexPath)!
        if let listTopics = self.datasource?.listTopics(for: self), let topic = listTopics[safe: indexPath.row] {
            cell.bind(topic: topic, isSelected: topic == self.selectedTopic || (indexPath.row == 0 && self.selectedTopic.isEmpty) )
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedTopic = self.datasource?.listTopics(for: self)[safe: indexPath.row] {
            self.delegate?.topicTabBarView(self, didSelect: selectedTopic)
            self.selectedTopic = selectedTopic
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TopicTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = Outfit.regularFont(size: CGFloat(self.fontSize))
        let topicName = self.datasource?.listTopics(for: self)[safe: indexPath.row] ?? ""
        let atttributes =  [NSAttributedString.Key.font: font]
        return CGSize(width: topicName.size(withAttributes: atttributes).width + TopicTabBarViewConst.cellPadding, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return TopicTabBarViewConst.cellSpacing
    }
}
