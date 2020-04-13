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
import Firebase

class TravelViewController: UIViewController {

    private var totalDistance : Int = 0
    
    var cars : [NSManagedObject] = []
    
    let dataManager : DatabaseManger = DatabaseManger()
    
    @IBOutlet weak var travelSelector: UISegmentedControl!
    
    @IBOutlet weak var carsPicker: UIPickerView!
    
    @IBOutlet weak var travelMV: MKMapView!
    
    
    @IBAction func backBTNPressed(_ sender: Any) {
        
        if recordingDistance == true
        {
            saveEmmissions(emission: Float(emmission))
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
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
            travelMV.showsUserLocation = true
            centreViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            
            break
        default:
            break
        }
    }
    
    var route : [CLLocationCoordinate2D] = []
    func centreViewOnUserLocation()
    {
        let latMeters : Double = 100
        let longMeters : Double = 100
        //the above variables state how much the map should be zoomed in
        
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: latMeters, longitudinalMeters: longMeters)
            travelMV.setRegion(region, animated: true)
            
            //route.append(location)
            
            //let line = MKPolyline(coordinates: route, count: route.count)
            
            //self.travelMV.addOverlay(line)
        }
    
    }
    
    func load()
    {
        
        dataManager.setUp()
        cars = dataManager.getVehicle()
        
        carsPicker.reloadAllComponents()
        
    }
    
    var previousLocation : CLLocation? = nil
    var distance : Double = 0
    
    @IBOutlet weak var distanceTXT: UILabel!
    
    var recordingDistance : Bool = false
    
    @IBOutlet weak var actionBTN: CustomTextButton!
    
    @IBAction func actionBTN(_ sender: Any) {
        if (recordingDistance == false)
        {
            startRecordong()
        }
        else{
            stopRecordong()
        }
    }
    
    func startRecordong()
    {
        setTravelType()
        actionBTN.setTitle("Stop", for: .normal)
        distance = 0
        recordingDistance = true
    }
    
    func stopRecordong()
    {
        actionBTN.setTitle("Start", for: .normal)
        recordingDistance = false
        saveEmmissions(emission: Float(emmission))
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveTravel()
    {
        
    }
    
    var travelType : String = ""
    var carbonPerMile : Double = 0.0
    func setTravelType()
    {
        travelType = travelSelector.titleForSegment(at: travelSelector.selectedSegmentIndex)!
        
        print("travel type is \(travelType)")
        
        if travelType == "Train"
        {
            setupTrain()
        }
        else if travelType == "Plane"
        {
            setupPlane()
        }
        else if travelType == "Car"
        {
            print("car selected")
            setupCar()
        }
        else{
            
        }
    }
    
    func setupPlane()
    {
        let collRef = Firestore.firestore().collection("plane")
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.carbonPerMile = result["consumption"] as? Double ?? 0.0
            }
            }
        
        }

    }
    
    func setupTrain()
    {
        let collRef = Firestore.firestore().collection("train")
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.carbonPerMile = result["consumption"] as? Double ?? 0.0
            }
            }
        
        }

    }
    
    func setupCar()
    {
        var carType : String = (cars[carsPicker.selectedRow(inComponent: 0)].value(forKey: "type") as? String)!
        
        print("car type is \(carType)")
        
        let collRef = Firestore.firestore().collection(carType)
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.carbonPerMile = result["consumption"] as? Double ?? 0.0
                print("consumption is \(self.carbonPerMile)")
            }
            }
        
        }
    }
    
    var emmission : Double = 0.0
    
    func saveEmmissions(emission : Float)
    {
        dataManager.setUp()
        dataManager.addEmmission(emission: emission)
    }
    
    
}

extension TravelViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latMeters : Double = 100
        let longMeters : Double = 100
        
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: latMeters, longitudinalMeters: longMeters)
        travelMV.setRegion(region, animated: true)
        
        if previousLocation == nil
        {
            previousLocation = location
        }
        else
        {
            let currentLocation = location
            let result = currentLocation.distance(from: previousLocation!)
            distance = distance + Measurement(value: result, unit: UnitLength.miles).value
            emmission = distance * carbonPerMile
            //print("distance is \(distance)")
            //print("carbon per mile is \(carbonPerMile)")
            //distance = round(distance / 0.01) * 0.01
            emmission = round(emmission / 10) * 10
            if (recordingDistance == true)
            {
                self.distanceTXT.text = "\(round(emmission / 100))"
            }
            
            //print("emission is \(emmission)")
            
            previousLocation = location
            
        }
        
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
