//
//  RecordViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 23/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var itemsTV: UITableView!
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var electronics : [NSManagedObject] = []
    
    var tableCells : [RecordTableViewCell] = []
    
    let dataManager : DatabaseManger = DatabaseManger()
    
    var domesticEmission : Float = 0.00
    var techEmission : Float = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        load()
        getFromOnline()
    }
    
    func getFromOnline()
    {
        let firestoreRef = Firestore.firestore()
        
        var collRef = firestoreRef.collection("domestic")
        
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.domesticEmission = Float(result["emissions"] as! NSNumber)
            }
        }
        }
        
        collRef = firestoreRef.collection("tech")
        
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.techEmission = Float(result["emissions"] as! NSNumber)
            }
        }
        }
        
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
        
        //3
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electronics.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! RecordTableViewCell
        
            cell.nameTXT.text = electronics[indexPath.row].value(forKey: "name") as? String
        
        tableCells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
              appDelegate.persistentContainer.viewContext
            
            let location = /*(electronics.count - 1) -*/ indexPath.row //because location 0 in an array is highest row number i.e. the row at the bottom has the largest row number
            
            let deletedObject = electronics[location]
            managedContext.delete(deletedObject)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
            load()
            
            tableView.reloadData()
        }
    }
    
    @IBAction func SaveBTNPressed(_ sender: Any) {
        
        var totalEmission : Float = 0.0
        
        for i in 0..<tableCells.count
        {
            let timeSelected : String = tableCells[i].selectedValue
            let type : String = electronics[i].value(forKey: "type") as! String
            
            var time : Float = 0.0 // in hours
            
            switch timeSelected
            {
            case "Not Used":
                time = 0.0;
            case "below 1":
                time = 0.50
            case "2 - 5":
                time = 4.0
            case "5 - 8":
                time = 6.0
            case "8 plus":
                time = 9.0
            default:
                time = 0.0
            }
            
            if type == "tech"
            {
                totalEmission += techEmission * time
            }
            else
            {
                totalEmission += domesticEmission * time
            }
            
        }
        
        let adding : Float = round(totalEmission / 0.01) * 0.01
        
        recordEmissions(adding: adding)
        
    }
    
    func recordEmissions(adding : Float)
    {
        //var result : [NSManagedObject] = []
        //var currentEmission : Float = 0
        
        /*
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext*/
        
        /*
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Emissions")
          result = try managedContext.fetch(fetchRequest)
            print("result size is \(result.count)")
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print("current emissions is \(currentEmission)")
        
        let entity =
        NSEntityDescription.entity(forEntityName: "Emissions", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
       
        
        item.setValue(adding, forKey: "total")
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }*/
        
        dataManager.setUp()
        dataManager.addEmmission(emission: adding)
    }
    

}
