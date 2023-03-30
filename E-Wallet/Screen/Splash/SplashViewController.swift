//
//  SplashViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol SplashPresentableListener: AnyObject {
}

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable {
    weak var listener: SplashPresentableListener?
}
