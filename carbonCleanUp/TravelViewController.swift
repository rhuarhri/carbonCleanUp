//
//  TravelViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 19/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class TravelViewController: UIViewController {

    var cars : [NSManagedObject] = []
    
    @IBOutlet weak var carsPicker: UIPickerView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationPermission()
        load()
    }
    
    func checkLocationPermission()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setUpManager()
            checkLocationAuthorised()
        }
        else
        {
            //no access to location
        }
    }
    
    func setUpManager()
    {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func checkLocationAuthorised()
    {
        switch CLLocationManager.authorizationStatus()
        {
        case .denied:
            
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //stopped by parental controls
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centreViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            
            break
        default:
            break
        }
    }
    
    func centreViewOnUserLocation()
    {
        let latMeters : Double = 100
        let longMeters : Double = 100
        //the above variables state how much the map should be zoomed in
        
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: latMeters, longitudinalMeters: longMeters)
            mapView.setRegion(region, animated: true)
        }
    
    }
    
    func load()
    {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        do {
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vehicle")
            cars = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        carsPicker.reloadAllComponents()
    }
    
    
    /*
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
        
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "NameItem")
      
      //3
      do {
        names = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    
    
    @IBAction func addBTN(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
          [unowned self] action in
                                        
          guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
              return
          }
          
            self.save(name: nameToSave)
            self.dataTable.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "NameItem",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      person.setValue(name, forKeyPath: "name")
      
      // 4
      do {
        try managedContext.save()
        names.append(person)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let person = names[indexPath.row]
        
        //cell.textLabel?.text = names[indexPath.row]
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        
        return cell
    }*/
    

}

extension TravelViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latMeters : Double = 100
        let longMeters : Double = 100
        
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: latMeters, longitudinalMeters: longMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //checkLocationPermission()
    }
}

extension TravelViewController: UIPickerViewDataSource
{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cars.count
    }
    
}

extension TravelViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cars[row].value(forKey: "name") as? String ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
