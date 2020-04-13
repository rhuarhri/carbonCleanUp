//
//  DonationViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 25/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import SquareInAppPaymentsSDK

class DonationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let database = DatabaseManger()
    
    //@IBOutlet weak var COTwoTXT: UILabel!
    @IBOutlet weak var BuyOffsetBTN: UIButton!
    @IBOutlet weak var TreeTXT: UILabel!
    
    @IBOutlet weak var charityTV: UITableView!
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var emissions : Float = 0
    var treesOwned : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        database.setUp()
        
        load()
    }
    
    func load()
    {
        getTotalEmissions()
        getTotalTrees()
        getCharities()
    }
    
    func getTotalEmissions()
    {
        /*
        var result : [NSManagedObject] = []
        var currentEmission : Float = 0
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Emissions")
          result = try managedContext.fetch(fetchRequest)
            if result.isEmpty == false
            {
                for i in result
                {
                    currentEmission += i.value(forKey: "total") as? Float ?? 1.0
                }
                
                currentEmission = round(currentEmission / 0.1) * 0.1
                //COTwoTXT.text = "\(currentEmission)"
                print("current emission is \(currentEmission)")
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }*/
        
        //var currentEmission : Float = database.getEmission()
        //COTwoTXT.text = currentEmission.description
    }
    
    func getTotalTrees()
    {
        /*
        var result : [NSManagedObject] = []
        var currentTotal : Int = 0
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Trees")
          result = try managedContext.fetch(fetchRequest)
            if result.isEmpty == false
            {
                for i in result
                {
                    currentTotal += i.value(forKey: "total") as? Int ?? 0
                }
                
                TreeTXT.text = "\(currentTotal)"
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }*/
        
        treesOwned = database.getTrees()
        TreeTXT.text = treesOwned.description
    }
    
    var charityNames : [String] = []
    var charityDescription : [String] = []
    
    func getCharities()
    {
        let collRef : CollectionReference = Firestore.firestore().collection("charities")
        
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.charityNames.append(result["name"] as? String ?? "error")
                self.charityDescription.append(result["description"] as? String ?? "error")
            }
        }
            self.charityTV.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityNames.count
    }
    
    var sharedTrees : Int = 0
    var charityList = [DonationTableViewCell]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DonationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! DonationTableViewCell
        
        charityList.append(cell)
        
        cell.name = charityNames[indexPath.row]
        cell.nameTXT.text = cell.name
        cell.descriptionTXT.text = charityDescription[indexPath.row]
        print("charity description is \(charityDescription[indexPath.row])")
        
        cell.action = {
            
            if Int(cell.AddTreeStepper.value) > cell.treeAmount
            {
                //add tree
                if self.treesOwned > self.sharedTrees
                {
                    cell.treeAmount = Int(cell.AddTreeStepper.value)
                    
                    self.sharedTrees += 1
                    
                    let newValue = self.treesOwned - self.sharedTrees
                    
                    self.TreeTXT.text = newValue.description
                }
            }
            else
            {
                //remove tree
                cell.treeAmount = Int(cell.AddTreeStepper.value)
                
                self.sharedTrees -= 1
                
                let newValue = self.treesOwned - self.sharedTrees
                
                self.TreeTXT.text = newValue.description
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    @IBAction func BuyOffsetBTNPressed(_ sender: Any) {
        
        
        //let theme = SQIPTheme()
        //theme.tintColor = .green
        
        //let cardEntry = SQIPCardEntryViewController(theme: theme)
        //cardEntry.delegate = PayViewController() as! SQIPCardEntryViewControllerDelegate
        
        //cardEntry.show(PayViewController(), sender: 0)
        
        //navigationController?.pushViewController(cardEntry, animated: true)
        
    }
    
    @IBAction func doneBTNPressed(_ sender: Any) {
        
        let updatedTreeAmount = treesOwned - sharedTrees
        
        database.updateTrees(newTreeAmount: updatedTreeAmount)
        
        for charity in charityList
        {
            let collRef : Query = Firestore.firestore().collection("charities").whereField("name", isEqualTo: charity.name)
            
            collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let newDonation : [String:Any] =
                    [
                        "amount" : charity.treeAmount
                    ]
                    
                    let charityRef = Firestore.firestore()
                        .collection("charities/\(document.documentID)/donations")
                    
                    charityRef.addDocument(data: newDonation)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
            }
            
            
        }
        
        
        
    }
    
}


