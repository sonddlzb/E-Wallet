//
//  DashboardViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol DashboardPresentableListener: AnyObject {
}

final class DashboardViewController: UIViewController, DashboardPresentable, DashboardViewControllable {
    weak var listener: DashboardPresentableListener?
}
