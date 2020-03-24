//
//  PayViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 24/03/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import Stripe

class PayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addBTNPressed(_ sender: Any) {
        
        
    }
    
    
    @IBAction func payBTNPressed(_ sender: Any) {
        
        /*
        // 1
        guard CheckoutCart.shared.canPay else {
          let alertController = UIAlertController(title: "Warning",
                                                  message: "Your cart is empty",
                                                  preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "OK", style: .default)
          alertController.addAction(alertAction)
          present(alertController, animated: true)
          return
        }*/
        /*
        // 2
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)*/
    }
    
}
/*
extension PayViewController: STPAddCardViewControllerDelegate {

  func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    navigationController?.popViewController(animated: true)
  }

  func addCardViewController(_ addCardViewController: STPAddCardViewController,
                             didCreateToken token: STPToken,
                             completion: @escaping STPErrorBlock) {
  }
}*/
