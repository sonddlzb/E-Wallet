//
//  BaseViewController.swift
//  Core
//
//  Created by Thanh Vu on 13/08/2021.
//

import UIKit

open class BaseViewControler: UIViewController {
    private var viewWillAppeared: Bool = false
    private var viewDidAppeared: Bool = false
    public var isDisplaying: Bool = false
    var progressIndicator1: UIActivityIndicatorView?

    // MARK: - Override setting
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Life cycle
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !viewWillAppeared {
            viewWillAppeared = true
            self.viewWillFirstAppear()
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDisplaying = true
        if !viewDidAppeared {
            viewDidAppeared = true
            self.viewDidFirstAppear()
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isDisplaying = false
    }

    open func viewWillFirstAppear() {
        // nothing
    }

    open func viewDidFirstAppear() {
        // nothing
    }

    open func viewWillDisappearByInteractive() {
        // nothing
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Alert
    func showAlert(title: String = "", message: String = "", titleButtons: [String] = ["OK"], destructiveIndexs: [Int] = [], action: ((Int) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        titleButtons.forEach { (titleButton) in
            let index = titleButtons.firstIndex(of: titleButton)!
            let style = destructiveIndexs.contains(index) ? UIAlertAction.Style.destructive : UIAlertAction.Style.default
            let alertAction = UIAlertAction.init(title: titleButton, style: style, handler: { (_) in
                action?(index)
            })

            alert.addAction(alertAction)
        }

        self.present(alert, animated: true, completion: nil)
    }

    func showAlertEdit(title: String = "", message: String = "", oldValue: String = "", titleButtons: [String] = ["OK"], action: ((Int, String) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.text = oldValue
        }

        titleButtons.forEach { (titleButton) in
            let index = titleButtons.firstIndex(of: titleButton)!
            let alertAction = UIAlertAction.init(title: titleButton, style: UIAlertAction.Style.default, handler: { (_) in
                let textField = alert.textFields?.first!
                action?(index, textField?.text ?? "")
            })

            alert.addAction(alertAction)
        }

        self.present(alert, animated: true, completion: nil)
    }

    func showLoadingAsync() {
        DispatchQueue.main.async {
            if self.progressIndicator1 == nil {
                self.progressIndicator1 = UIActivityIndicatorView()
                self.progressIndicator1?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                self.progressIndicator1?.layer.cornerRadius = 10.0
                self.progressIndicator1?.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
                self.progressIndicator1?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
                self.progressIndicator1?.hidesWhenStopped = true
                self.progressIndicator1?.style = UIActivityIndicatorView.Style.whiteLarge
                self.progressIndicator1?.color = UIColor.init(red: 20.0/255.0, green: 140.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                self.view.addSubview(self.progressIndicator1!)
            }

            self.progressIndicator1?.startAnimating()
            self.progressIndicator1?.isHidden = false
        }
    }

    func hideLoadingAsync() {
        DispatchQueue.main.async {
            self.progressIndicator1?.stopAnimating()
            self.progressIndicator1?.isHidden = true
        }
    }
}
