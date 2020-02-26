//
//  ViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 12/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//  Created by Rhuarhri Cordon
//

import UIKit
import Charts
import CoreData
import Firebase


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //core data will store achieved acheivements
    //firebase will store one yet ot be completed
    
    @IBOutlet weak var userPerformanceChart: LineChartView!
    
    
    @IBOutlet weak var COTwoDataView: UIView!
    @IBOutlet weak var COTwoDataTXT: UILabel!
    
    
    @IBOutlet weak var TreeDataView: UIView!
    @IBOutlet weak var TreeDataTXT: UILabel!
    
    @IBOutlet weak var OffsetBTN: UIButton!
    @IBOutlet weak var travelBTN: UIButton!
    @IBOutlet weak var shoppingBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        COTwoDataView.layer.cornerRadius = 15.0
        TreeDataView.layer.cornerRadius = 15.0
        OffsetBTN.layer.cornerRadius = 15.0
        travelBTN.layer.cornerRadius = 15.0
        shoppingBTN.layer.cornerRadius = 15.0
        
        userPerformanceChart.chartDescription?.text = "description"
        let lineColour = UIColor.white //UIColor(red: 0.30, green: 0.62, blue: 0.23, alpha: 1.0);
        userPerformanceChart.gridBackgroundColor = lineColour
        
        let ll = ChartLimitLine(limit: 10.0, label: "Average")
        ll.lineColor = UIColor.blue
        userPerformanceChart.rightAxis.addLimitLine(ll)
        
        setChartValues()
        
        load()
    }
    
    func load()
    {
        var result : [NSManagedObject] = []
        var currentEmission : Float = 0
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        
        do {
            
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Emissions")
          result = try managedContext.fetch(fetchRequest)
            if result.isEmpty == false
            {
                for i in result
                {
                    currentEmission += i.value(forKey: "total") as? Float ?? 1.0
                }
                
                currentEmission = round(currentEmission / 0.1) * 0.1
                COTwoDataTXT.text = "\(currentEmission)"
                print("current emission is \(currentEmission)")
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func setChartValues(count : Int = 20)
    {
        
        
        let values = (0 ..< count).map{(i) -> ChartDataEntry in
            let val = Double(i)//Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(entries: values, label: "dataset1")
        set1.colors = [UIColor.white]
        set1.drawCirclesEnabled = false
        set1.drawFilledEnabled = true
        let lineColour = UIColor(red: 0.30, green: 0.62, blue: 0.23, alpha: 1.0);//UIColor.white
        set1.fillColor = lineColour
        set1.fillAlpha = 0.8
        let data = LineChartData(dataSet: set1)
        
        self.userPerformanceChart.data = data
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AchievementsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! AchievementsTableViewCell
        
            //cell.nameTXT.text = electronics[indexPath.row].value(forKey: "name") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }



}



