//
//  PaymentViewController.swift
//  FYP
//
//  Created by yoshi on 6/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    var type: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func addOrder(_ sender: Any) {
        
        APIManager.shared.getOrder { (json) in
            
            if !((json?["order"]["status"].exists())!) || json?["order"]["status"] == "Delivered" {
                let card = STPCardParams()
                card.number = self.cardTextField.cardNumber
                card.expMonth = self.cardTextField.expirationMonth
                card.expYear = self.cardTextField.expirationYear
                card.cvc = self.cardTextField.cvc
                
                print(card)
                
                STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
                    
                    if let error = error {
                        print("Error:", error)
                    } else if let stripeToken = token {
                        if self.type == "default"{
                            APIManager.shared.addOrder(stripeToken: stripeToken.tokenId) { (json) in
                                Cart.currentCart.reset()
                                self.performSegue(withIdentifier: "ViewOrder", sender: self)
                            }
                        } else{
                            APIManager.shared.addCustomizedOrder(stripeToken: stripeToken.tokenId) { (json) in
                                customizedCart.currentCustomizedCart.reset()
                                    self.performSegue(withIdentifier: "ViewOrder", sender: self)

                            }
                        }
                    }
                })
                
            } else {
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                let confirmAction = UIAlertAction(title: "Go to order", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "ViewOrder", sender: self)
                })
                
                let alert = UIAlertController(title: "Order already?", message: "Please order after the last order is completed.", preferredStyle: .alert)
                
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


