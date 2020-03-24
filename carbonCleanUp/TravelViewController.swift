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
        
        /*
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
        }*/
        
        dataManager.setUp()
        cars = dataManager.getVehicle()
        
        carsPicker.reloadAllComponents()
        
        //drawRoute()
        
        
    }
    
    /*
    func drawRoute()
    {
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        var route : [CLLocationCoordinate2D] = []
        route.append(sourceLocation)
        route.append(destinationLocation)
        
        let line = MKPolyline(coordinates: route, count: route.count)
        
        self.travelMV.addOverlay(line)
        
    }
    
    func recordRoute()
    {
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.travelMV.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.travelMV.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.travelMV.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }*/
    
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
        //should move into class
        
        /*
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
         NSEntityDescription.entity(forEntityName: "Emissions", in: managedContext)
         
         let item = NSManagedObject(entity: entity!, insertInto: managedContext)
         
        
         
         item.setValue(emmission, forKey: "total")
         
         do{
             try managedContext.save()
         }
         catch
         {
             print(error)
         }*/
        
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
            emmission = round(emmission / 100) //* 0.01
            if (recordingDistance == true)
            {
                self.distanceTXT.text = "\(emmission)"
            }
            
            print("emission is \(emmission)")
            
            previousLocation = location
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //checkLocationPermission()
    }
    
    /*
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Make sure we are rendering a polyline.
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        // Create a specialized polyline renderer and set the polyline properties.
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .black
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }*/
    
}

/*
extension TravelViewController: MKMapViewDelegate
{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Make sure we are rendering a polyline.
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        // Create a specialized polyline renderer and set the polyline properties.
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .black
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
}*/

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
