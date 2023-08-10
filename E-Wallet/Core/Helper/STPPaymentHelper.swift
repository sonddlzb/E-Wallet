//
//  STPPaymentHelper.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

enum PaymentType: String, CaseIterable {
    case electricity = "Electricity"
    case internet = "Internet"
    case water = "Water"
    case televison = "Tv"
    case topUp = "Top Up"
    case withdraw = "Withdraw"
    case transfer = "Transfer"
}

import Foundation
import Stripe
import FirebaseAuth

class STPPaymentHelper {
    static let shared = STPPaymentHelper()
    unowned var viewController: UIViewController!
    private let server = "https://stripe-et34.onrender.com"

    func handlePayment(card: Card,
                       price: Double,
                       paymentType: PaymentType,
                       completion: @escaping (_ error: Error?) -> Void) {
        let cardParams = STPCardParams()
        cardParams.number = card.cardNumber
        cardParams.expMonth = UInt(card.expirationMonth)
        cardParams.expYear = UInt(card.expirationYear)
        cardParams.cvc = card.cvc

        STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
            if let error = error {
                completion(error)
            } else {
                print("Received token \(token)")
                self.createPaymentIntent(card: card,
                                         token: token?.tokenId ?? "",
                                         price: price,
                                         paymentType: paymentType) { result in
                    switch result {
                    case .success(let clientSecret):
                        print("\(clientSecret) client secret.")
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                        return
                    }
                }
            }
        }
    }

    func createPaymentIntent(card: Card,
                             token: String,
                             price: Double,
                             paymentType: PaymentType,
                             completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: self.server + "/create-payment-intent") else {
            completion(.failure(NSError(domain: "Unknown error", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "amount": Int(price * 100),
            "token": token,
            "description": paymentType.rawValue
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }

            if response.statusCode == 200 {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let clientSecret = responseJSON?["client_secret"] as? String

                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret ?? "")

                    // Submit the payment
                    let paymentMethodParams = STPPaymentMethodCardParams()
                    paymentMethodParams.number = card.cardNumber
                    paymentMethodParams.expMonth = NSNumber(value: card.expirationMonth)
                    paymentMethodParams.expYear = NSNumber(value: card.expirationYear)
                    paymentMethodParams.cvc = card.cvc

                    let billingDetails = STPPaymentMethodBillingDetails()
                    billingDetails.name = Auth.auth().currentUser?.phoneNumber ?? "Unknown"

                    paymentIntentParams.paymentMethodParams =
                        STPPaymentMethodParams(card: paymentMethodParams,
                                               billingDetails: billingDetails,
                                               metadata: nil)
                    let paymentHandler = STPPaymentHandler.shared()

                    paymentHandler.confirmPayment(paymentIntentParams, with: self.viewController as! STPAuthenticationContext) { (status, paymentIntent, error) in
                        switch status {
                        case .failed:
                            print("Payment failed!")
                            completion(.failure(error!))
                        case .canceled:
                            print("Payment successfully!")
                            completion(.failure(error!))
                        case .succeeded:
                            print("Payment successfully!")
                            completion(.success(clientSecret ?? ""))
                        @unknown default:
                            fatalError()
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "Server returned status code \(response.statusCode)",
                                    code: response.statusCode,
                                    userInfo: nil)
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
