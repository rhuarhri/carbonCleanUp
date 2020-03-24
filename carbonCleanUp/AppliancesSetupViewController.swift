//
//  AppliancesSetupViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 17/03/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class AppliancesSetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemsTV: UITableView!
    
    @IBOutlet weak var electronicsTypeSelector: UISegmentedControl!
    @IBOutlet weak var electronicsNameTF: UITextField!
    
    var electronics : [NSManagedObject] = []
    let dataManager : DatabaseManger = DatabaseManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Electronics")
          electronics = try managedContext.fetch(fetchRequest)
            
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }*/
        
        dataManager.setUp()
        electronics = dataManager.getApplicances()
        
    }
    
    func save(name : String, type : String)
    {
        /*
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "Electronics", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(name, forKey: "name")
        item.setValue(type, forKey: "type")
        
        
        electronics.append(item)
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }*/
        
        
        dataManager.setUp()
        electronics.append(dataManager.addApplicances(name: name, type: type))
        
        itemsTV.reloadData()
        
    }
    
    @IBAction func electricalItemsQuestionBTNPressed(_ sender: Any) {
        
        /*
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
        }*/
        
        self.performSegue(withIdentifier: "showHelpPopup", sender: nil)
        
    }
    
    func getInstruction() -> String
    {
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
            }
        }
        }
        
        return instructions
    }
    
    @IBAction func addElectronicsBTN(_ sender: Any) {
        
        let electronicType = electronicsTypeSelector.titleForSegment(at: electronicsTypeSelector.selectedSegmentIndex)!
        save(name: electronicsNameTF.text!, type: electronicType)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHelpPopup"
        {
            if let destination = segue.destination as? PopupViewController
            {
                destination.message = "items"
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electronics.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
    
        
        cell.typeTXT.text = electronics[indexPath.row].value(forKey: "type") as? String
        cell.nameTXT.text = electronics[indexPath.row].value(forKey: "name") as? String
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

}
