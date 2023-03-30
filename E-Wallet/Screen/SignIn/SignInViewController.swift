//
//  SignInViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol SignInPresentableListener: AnyObject {
}

final class SignInViewController: UIViewController, SignInPresentable, SignInViewControllable {
    weak var listener: SignInPresentableListener?
}
