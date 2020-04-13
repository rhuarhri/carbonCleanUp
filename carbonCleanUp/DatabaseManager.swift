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
                
                let currentEmissions = result[(result.endIndex - 1)].value(forKey: "total")
                    as? Float ?? 0.0
                
                
                
                emission = round(currentEmissions / 0.1) * 0.1
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return emission
    }
    
    func getAllEmissions() -> [Float]
    {
        var emissionHistory = [Float]()
        
        var result : [NSManagedObject] = []
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Emissions")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                for i in result
                {
                    var emission : Float = i.value(forKey: "total") as? Float ?? 0.0
                    emission = round(emission / 0.1) * 0.1
                    emissionHistory.append(emission)
                }
                
            }
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        
        return emissionHistory
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
    
    func getOffsetAmount() -> Float
    {
        var cardonOffset : Float = 0.0
        
        var result : [NSManagedObject] = []
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "CarbonOffset")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                cardonOffset = result[(result.endIndex - 1)].value(forKey: "amount") as? Float ?? 0.0
            }
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        
        return cardonOffset
    }
    
    func addOffsetAmount(reductionAmount : Float)
    {
        var result : [NSManagedObject] = []
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "CarbonOffset")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                let currentOffset = result[(result.endIndex - 1)].value(forKey: "amount") as? Float ?? 0.0
                result[(result.endIndex - 1)].setValue((currentOffset + reductionAmount), forKey: "amount")
                
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
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
    
    func updateVehicle(oldName : String, name : String, type : String, fuel : String)
    {
        var result : [NSManagedObject] = []
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Vehicle")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                
                for item in result
                {
                    if item.value(forKey: "name") as? String == oldName
                    {
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
                    }
                }
                
            }
            else
            {
                
            }
            
            do{
                try managedContext!.save()
            }
            catch
            {
                print(error)
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteVehicle(oldName : String)
    {
        var result : [NSManagedObject] = []
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Vehicle")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                
                for item in result
                {
                    if item.value(forKey: "name") as? String == oldName
                    {
                        managedContext!.delete(item)
                        
                        do{
                            try managedContext!.save()
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                }
            }
            }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
                   
        }
        
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
    
    func getTrees() -> Int
    {
        
        var result : [NSManagedObject] = []
        var trees : Int = 0
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Trees")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                /*
                for i in result
                {
                    trees += i.value(forKey: "total") as? Int ?? 0
                }*/
                
                let item = result[(result.endIndex - 1)]
                trees = item.value(forKey: "total") as? Int ?? 0
                
                
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return trees
        
    }
    
    func updateTrees(newTreeAmount : Int)
    {
        var result : [NSManagedObject] = []
        //var trees : Int = 0
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Trees")
          result = try managedContext!.fetch(fetchRequest)
            if result.isEmpty == false
            {
                
                let item = result[(result.endIndex - 1)]
                item.setValue(newTreeAmount, forKey: "total")
                
            }
            else
            {
                let entity =
                NSEntityDescription.entity(forEntityName: "Trees", in: managedContext!)
                
                let item = NSManagedObject(entity: entity!, insertInto: managedContext)
                
                item.setValue(newTreeAmount, forKey: "total")
            }
            
            do{
                try managedContext!.save()
            }
            catch
            {
                print(error)
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /*
    func addTrees(newTreeAmount : Int)
    {
        let entity =
        NSEntityDescription.entity(forEntityName: "Trees", in: managedContext!)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(newTreeAmount, forKey: "total")
        
        do{
            try managedContext!.save()
        }
        catch
        {
            print(error)
        }
    }*/
    
}
