//
//  CarSetupViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 17/03/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CarSetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var itemsTV: UITableView!
    
    @IBOutlet weak var vehicleTypeSelector:UISegmentedControl!
    @IBOutlet weak var vehicleNameTF:UITextField!
    
    var vehicles : [NSManagedObject] = []
    let dataManager : DatabaseManger = DatabaseManger()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        load()
    }
    
    func load()
    {
        /*
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        
        do {
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vehicle")
            vehicles = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }*/
        
        dataManager.setUp()
        vehicles = dataManager.getVehicle()
        
    }
    
    func save(name : String, type : String, fuel : String?)
    {
        /*
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "Vehicle", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(name, forKey: "name")
        item.setValue(type, forKey: "type")
        
        item.setValue(fuel!, forKey: "fuel")
        
    
        vehicles.append(item)
        
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }*/
        
        dataManager.setUp()
        vehicles.append(dataManager.addVehicle(name : name, type : type, fuel : fuel!))
        
        itemsTV.reloadData()
        
    }
    
    @IBAction func vehiclesQuestionBTNPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showHelpPopup", sender: nil)
        
        
        /*
        
        var instructions : String = ""
        
        let collRef : CollectionReference = Firestore.firestore().collection("instructions")
        
        let helpQuery = collRef.whereField("type", isEqualTo: "vehicle")
        
        helpQuery.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                instructions = result["help"] as? String ?? "Unable to find anything."
                self.performSegue(withIdentifier: "showHelpPopup", sender: instructions)
            }
        }
        }
        
        
        let instructions : String = "Small vehicles are anything smaller or the same size as a hatchback like a mini copper. \nLarge vehicles are anything that is the same size as a people carrier or 4 by 4 like a land rover. \nVans are anything bigger than a 4 by 4 like a ford transit. \nLorries are anything larger than a van like a tractor. \nIf you have a hybrid vehicle move it to on option below so a large hybrid is considered a small vehicle. \nIf you are unsure which option to choose, pick the higher option for example if you have a choose between small and large pick large. \nThis question does not apply to electric cars."*/
        
    }
    
    @IBAction func addVehicleBTN(_ sender: Any)
    {
        let vehicleType : String = vehicleTypeSelector.titleForSegment(at: vehicleTypeSelector.selectedSegmentIndex)!
        var vehicleFuel = vehicleType == "small car" ?
        "petrol" : "diesel"
        
        save(name: vehicleNameTF.text!, type: vehicleType, fuel: vehicleFuel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHelpPopup"
        {
            if let destination = segue.destination as? PopupViewController
            {
                destination.message = "vehicle"
                //print((sender! as? String)!)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
    
        
        cell.typeTXT.text = vehicles[indexPath.row].value(forKey: "type") as? String
        cell.nameTXT.text = vehicles[indexPath.row].value(forKey: "name") as? String
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

}
