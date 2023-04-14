//
//  AddCardInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs
import RxSwift
import SVProgressHUD
import Stripe
import FirebaseAuth

protocol AddCardRouting: ViewableRouting {
}

protocol AddCardPresentable: Presentable {
    var listener: AddCardPresentableListener? { get set }

    func bindAddCardResult(isSuccess: Bool)
}

protocol AddCardListener: AnyObject {
    func addCardWantToDismiss()
    func addCardWantToReloadData()
}

final class AddCardInteractor: PresentableInteractor<AddCardPresentable>, AddCardInteractable {

    weak var router: AddCardRouting?
    weak var listener: AddCardListener?

    override init(presenter: AddCardPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func typeOfCreditCard(cardNumber: String) -> CardType {
        for cardType in CardType.allCases {
            if cardNumber.matches(regex: cardType.regex()) {
                return cardType
            }
        }

        return .masterCard
    }
}

// MARK: - AddCardPresentableListener
extension AddCardInteractor: AddCardPresentableListener {
    func didTapAddNewCardButton(cardParam: STPCardParams) {
            SVProgressHUD.show()
            STPAPIClient.shared.createToken(withCard: cardParam) { token, error in
                if let error = error {
                    // Xử lý lỗi
                    SVProgressHUD.dismiss()
                    print("get error for creating token : \(error)!")
                } else if let token = token {
                    print("Received token \(token)")
                    let cardEntity = CardEntity(cardNumber: cardParam.number ?? "",
                                                expirationMonth: Int(cardParam.expMonth),
                                                expirationYear: Int(cardParam.expYear) + 2000,
                                                userId: Auth.auth().currentUser?.uid ?? "",
                                                cvc: cardParam.cvc ?? "",
                                                token: token.tokenId,
                                                type: self.typeOfCreditCard(cardNumber: cardParam.number ?? "").rawValue)
                    CardDatabase.shared.addNewCard(cardEntity: cardEntity) { successfully in
                        SVProgressHUD.dismiss()
                        self.presenter.bindAddCardResult(isSuccess: successfully == true)
                    }
                }
            }
    }

    func addCardWantToDismiss() {
        self.listener?.addCardWantToDismiss()
    }

    func addCardWantToReloadData() {
        self.listener?.addCardWantToReloadData()
    }
}
