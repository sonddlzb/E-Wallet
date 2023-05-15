//
//  MyQRViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs
import RxSwift
import UIKit
import EFQRCode

protocol MyQRPresentableListener: AnyObject {
}

final class MyQRViewController: UIViewController, MyQRViewControllable {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!

    // MARK: - Variables
    weak var listener: MyQRPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - MyQRPresentable
extension MyQRViewController: MyQRPresentable {
    func bind(viewModel: MyQRViewModel) {
        self.loadViewIfNeeded()
        self.nameLabel.text = viewModel.name()
        self.phoneNumberLabel.text = viewModel.phoneNumber()
        if let image = EFQRCode.generate(for: viewModel.phoneNumber()) {
            self.imageView.image = UIImage(cgImage: image)
        }
    }
}
