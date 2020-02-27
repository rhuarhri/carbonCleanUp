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

class DonationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var COTwoTXT: UILabel!
    @IBOutlet weak var BuyOffsetBTN: UIButton!
    @IBOutlet weak var TreeTXT: UILabel!
    
    @IBOutlet weak var charityTV: UITableView!
    
    
    var emissions : Float = 0
    var treesOwned : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
                COTwoTXT.text = "\(currentEmission)"
                print("current emission is \(currentEmission)")
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getTotalTrees()
    {
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
        }
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DonationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! DonationTableViewCell
        
        cell.nameTXT.text = charityNames[indexPath.row]
        cell.descriptionTXT.text = charityDescription[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    @IBAction func BuyOffsetBTNPressed(_ sender: Any) {
    }
    
}
