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
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }
    
    func load()
    {
        dataManager.setUp()
        electronics = dataManager.getApplicances()
        
    }
    
    func save(name : String, type : String)
    {
        dataManager.setUp()
        electronics.append(dataManager.addApplicances(name: name, type: type))
        
        itemsTV.reloadData()
        
    }
    
    @IBAction func electricalItemsQuestionBTNPressed(_ sender: Any) {
        
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
        return 55
    }

}
