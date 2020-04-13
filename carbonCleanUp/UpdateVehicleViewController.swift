//
//  UpdateVehicleViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 11/04/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData

class UpdateVehicleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let dataManager : DatabaseManger = DatabaseManger()
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteBTNPressed(_ sender: Any){
        
        if (oldName != "")
        {
            dataManager.deleteVehicle(oldName: oldName)
        }
        
    }
    
    @IBOutlet weak var typeSelector: UISegmentedControl!
    
    @IBOutlet weak var nameTF: CustomTextField!
    
    @IBAction func AddBTNPressed(_ sender: Any) {
        
        let vehicleType : String = typeSelector.titleForSegment(at: typeSelector.selectedSegmentIndex)!
        let vehicleFuel = vehicleType == "small car" ?
        "petrol" : "diesel"
        
        dataManager.addVehicle(name: nameTF.text!, type: vehicleType, fuel: vehicleFuel)
        
    }
    
    @IBAction func UpdateBTNPressed(_ sender: Any){
        if (oldName != "")
        {
            let vehicleType : String = typeSelector.titleForSegment(at: typeSelector.selectedSegmentIndex)!
            let vehicleFuel = vehicleType == "small car" ?
            "petrol" : "diesel"
            
            dataManager.updateVehicle(oldName: oldName, name: nameTF.text!, type: vehicleType, fuel: vehicleFuel)
        }
    }
    
    var vehicles : [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }

    func load()
    {
        dataManager.setUp()
        vehicles = dataManager.getVehicle()
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
        return 55
    }
    var oldName : String = ""
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        oldName = vehicles[indexPath.row].value(forKey: "name") as? String ?? ""
        self.nameTF.text = oldName
        
        print("item selected")
    }
}
