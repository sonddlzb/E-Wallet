//
//  AccountViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol AccountPresentableListener: AnyObject {
    func routeToAddCard()
}

final class AccountViewController: UIViewController, AccountPresentable, AccountViewControllable {
    weak var listener: AccountPresentableListener?

    @IBAction func didTapAddCardButton(_ sender: Any) {
        self.listener?.routeToAddCard()
    }
}
