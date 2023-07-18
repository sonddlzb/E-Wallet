//
//  GiftAreaViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import RIBs
import RxSwift
import UIKit

protocol GiftAreaPresentableListener: AnyObject {
    func openService(_ serviceType: ServiceType)
    func didTapBack()
}

final class GiftAreaViewController: UIViewController, GiftAreaViewControllable {

    // MARK: - Outlets

    @IBOutlet weak var serviceListView: ServiceListView!
    // MARK: - Variables
    weak var listener: GiftAreaPresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.serviceListView.delegate = self
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBack()
    }
}

// MARK: - ServiceListViewDelegate
extension GiftAreaViewController: ServiceListViewDelegate {
    func serviceListView(_ serviceListView: ServiceListView, didSelectAt serviceType: ServiceType) {
        self.listener?.openService(serviceType)
    }
}

// MARK: - GiftAreaPresentable
extension GiftAreaViewController: GiftAreaPresentable {
    func bind(viewModel: ServiceViewModel) {
        self.loadViewIfNeeded()
        self.serviceListView.bind(viewModel: viewModel)
    }
}
