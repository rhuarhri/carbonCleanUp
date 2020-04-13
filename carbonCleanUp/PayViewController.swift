//
//  PayViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 24/03/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import Firebase

class PayViewController: UIViewController {
    
    let database = DatabaseManger()

    @IBOutlet weak var co2AmountTXT: UILabel!
    var co2Amount : Float = 0.0
    
    @IBOutlet weak var treeAmountTXT: UILabel!
    var treeAmount : Int = 0
    
    @IBOutlet weak var priceTXT: UILabel!
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        load()
        getEmmissionReductionRate()
    }
    
    
    func load()
    {
        database.setUp()
        
        co2Amount = database.getEmission()
        
        co2AmountTXT.text = co2Amount.description
    }
    
    @IBAction func addTreesBTN(_ sender: Any) {
        
        let stepper : UIStepper = sender as! UIStepper
        
        treeAmount = Int(stepper.value)
        
        treeAmountTXT.text = treeAmount.description
        
        updateEmmissions()
        
    }
    
    var emmissionReductionRate : Float = 0.0
    var treePrice : Float = 0.0
    func getEmmissionReductionRate()
    {
        let collRef = Firestore.firestore().collection("tree")
        
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                let foundEmmission = result["emissions"] as? Float
                //let foundPrice = result["cost"] as? Float
                let foundPrice = result["price"] as? String
                if (foundEmmission !=  nil && foundPrice != nil)
                {
                    self.emmissionReductionRate = foundEmmission!
                    self.treePrice = round((Float(foundPrice!) as! Float) / 0.01) * 0.01
                    print("Tree price is \(foundPrice!)")
                }
            }
        }
        }
    }
    
    func updateEmmissions()
    {
        let updateEmmissions = Float(treeAmount) * emmissionReductionRate
        
        let newCo2Amount = round((co2Amount - updateEmmissions) / 0.1) * 0.1
        
        co2AmountTXT.text = newCo2Amount.description
        
        let updatePrice = round((Float(treeAmount) * treePrice) / 0.01) * 0.01
        
        priceTXT.text = updatePrice.description
    }
    
    @IBAction func payBTNPressed(_ sender: Any) {
        
        //save emmissions
        
        let updatedEmmission : Float = round(
            (co2Amount - (Float(treeAmount) * emmissionReductionRate)) / 0.1) * 0.1
        
        database.addOffsetAmount(reductionAmount:
            round((Float(treeAmount) * emmissionReductionRate) / 0.1) * 0.1)
        
        database.addEmmission(emission: updatedEmmission)
        
        let ownedTrees = database.getTrees()
        
        database.updateTrees(newTreeAmount: (treeAmount + ownedTrees))
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
