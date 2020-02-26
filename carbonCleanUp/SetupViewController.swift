//
//  SetupViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 13/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var itemsTV: UITableView!
    
    @IBOutlet weak var electronicsTypeSelector: UISegmentedControl!
    @IBOutlet weak var electronicsNameTF: UITextField!
    
    @IBOutlet weak var vehicleTypeSelector:UISegmentedControl!
    @IBOutlet weak var vehicleNameTF:UITextField!
    @IBOutlet weak var vehicleFuelSelector:UISegmentedControl!
    
    
    var electronics : [NSManagedObject] = []
    var vehicles : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        //self.itemsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        load()
    }
    
    func load()
    {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //3
        do {
            
        var fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Electronics")
          electronics = try managedContext.fetch(fetchRequest)
            
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vehicle")
            vehicles = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func save(isVehicle : Bool, name : String, type : String, fuel : String?)
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        let entity = isVehicle == true ?
        NSEntityDescription.entity(forEntityName: "Vehicle", in: managedContext) :
        NSEntityDescription.entity(forEntityName: "Electronics", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(name, forKey: "name")
        item.setValue(type, forKey: "type")
        
        if (isVehicle == true)
        {
            item.setValue(fuel!, forKey: "fuel")
        }
        
        if isVehicle == true
        {
            vehicles.append(item)
        }
        else
        {
            electronics.append(item)
        }
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
        
        itemsTV.reloadData()
        
    }
    
    @IBAction func GoToBTNPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToHomeScreen", sender: nil)
    }
    
    @IBAction func electricalItemsQuestionBTNPressed(_ sender: Any) {
        
        var instructions : String = ""
        
        let collRef : CollectionReference = Firestore.firestore().collection("instructions")
        
        let helpQuery = collRef.whereField("type", isEqualTo: "items")
        
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
        
    }
    
    @IBAction func addElectronicsBTN(_ sender: Any) {
        
        let electronicType = electronicsTypeSelector.titleForSegment(at: electronicsTypeSelector.selectedSegmentIndex)!
        save(isVehicle: false, name: electronicsNameTF.text!, type: electronicType, fuel : nil)
        
    }
    
    @IBAction func vehiclesQuestionBTNPressed(_ sender: Any) {
        
        
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
        
        /*
        let instructions : String = "Small vehicles are anything smaller or the same size as a hatchback like a mini copper. \nLarge vehicles are anything that is the same size as a people carrier or 4 by 4 like a land rover. \nVans are anything bigger than a 4 by 4 like a ford transit. \nLorries are anything larger than a van like a tractor. \nIf you have a hybrid vehicle move it to on option below so a large hybrid is considered a small vehicle. \nIf you are unsure which option to choose, pick the higher option for example if you have a choose between small and large pick large. \nThis question does not apply to electric cars."*/
        
    }
    
    @IBAction func addVehicleBTN(_ sender: Any)
    {
        let vehicleType : String = vehicleTypeSelector.titleForSegment(at: vehicleTypeSelector.selectedSegmentIndex)!
        let vehicleFuel : String = vehicleFuelSelector.titleForSegment(at: vehicleFuelSelector.selectedSegmentIndex)!
        
        save(isVehicle: true, name: vehicleNameTF.text!, type: vehicleType, fuel: vehicleFuel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHelpPopup"
        {
            if let destination = segue.destination as? PopupViewController
            {
                destination.message = (sender! as? String)!
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electronics.count + vehicles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        
        if indexPath.row < electronics.count
        {
            cell.typeTXT.text = electronics[indexPath.row].value(forKey: "type") as? String
            cell.nameTXT.text = electronics[indexPath.row].value(forKey: "name") as? String
        }
        else
        {
            let currentLocation = indexPath.row - electronics.count
            cell.typeTXT.text = vehicles[currentLocation].value(forKey: "type") as? String
            cell.nameTXT.text = vehicles[currentLocation].value(forKey: "name") as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}
