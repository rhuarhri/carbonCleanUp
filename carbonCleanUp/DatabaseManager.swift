//
//  DatabaseManager.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 23/03/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class DatabaseManger
{
    
    private var managedContext : NSManagedObjectContext? = nil
    
    func setUp()
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func databaseEmpty() -> Bool
    {
        let applicancesAmount = getApplicances().count
        
        if (applicancesAmount == 0)
        {
            //database empty
            return true
        }
        else
        {
            return false
        }
    }
    
    func getEmission() -> Float
    {
        var result : [NSManagedObject] = []
        var emission : Float = 0.0
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Emissions")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                for i in result
                {
                    emission += i.value(forKey: "total") as? Float ?? 1.0
                }
                
                emission = round(emission / 0.1) * 0.1
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return emission
    }
    
    func addEmmission(emission : Float)
    {
        let newEmission = round(emission / 0.1) * 0.1
        
        let entity =
         NSEntityDescription.entity(forEntityName: "Emissions", in: managedContext!)
         
         let item = NSManagedObject(entity: entity!, insertInto: managedContext)
         
         item.setValue(newEmission, forKey: "total")
         
         do{
             try managedContext!.save()
         }
         catch
         {
             print(error)
         }
    }
    
    func getVehicle() -> [NSManagedObject]
    {
        var vehicles : [NSManagedObject] = []
        
        do {
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vehicle")
            vehicles = try managedContext!.fetch(fetchRequest)
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return vehicles
    }
    
    func addVehicle(name : String, type : String, fuel : String) -> NSManagedObject
    {
        let entity =
            NSEntityDescription.entity(forEntityName: "Vehicle", in: managedContext!)
            
            let item = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            item.setValue(name, forKey: "name")
            item.setValue(type, forKey: "type")
            
            item.setValue(fuel, forKey: "fuel")
            
            do{
                try managedContext!.save()
            }
            catch
            {
                print(error)
            }
        
        return item
    }
    
    func addApplicances(name : String, type : String) -> NSManagedObject
    {
        let entity =
        NSEntityDescription.entity(forEntityName: "Electronics", in: managedContext!)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext!)
        
        item.setValue(name, forKey: "name")
        item.setValue(type, forKey: "type")
        
        do{
            try managedContext!.save()
        }
        catch
        {
            print(error)
        }
        
        return item

    }
    
    func getApplicances() -> [NSManagedObject]
    {
        
        var electronics : [NSManagedObject] = []
        do {
            
            let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Electronics")
            electronics = try managedContext!.fetch(fetchRequest)
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return electronics
    }
    
    
    
}
