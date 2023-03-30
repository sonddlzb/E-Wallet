//
//  RootViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    weak var listener: RootPresentableListener?
}
