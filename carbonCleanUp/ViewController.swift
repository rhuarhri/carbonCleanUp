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
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var COTwoDataView: UIView!
    @IBOutlet weak var COTwoDataTXT: UILabel!
    
    
    @IBOutlet weak var TreeDataView: UIView!
    @IBOutlet weak var TreeDataTXT: UILabel!
    
    @IBOutlet weak var OffsetBTN: UIButton!
    @IBOutlet weak var travelBTN: UIButton!
    @IBOutlet weak var shoppingBTN: UIButton!
    
    @IBOutlet weak var achievementsTV: UITableView!
    
    let database = DatabaseManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        userPerformanceChart.chartDescription?.text = "carbon footprint history"
        let lineColour = UIColor.white
        userPerformanceChart.gridBackgroundColor = lineColour
        
        let ll = ChartLimitLine(limit: 20000, label: "Average")
        ll.lineColor = UIColor.blue
        userPerformanceChart.rightAxis.addLimitLine(ll)
        
        load()
    }
    
    var currentEmission : Float = 0
    var currentOffset : Float = 0.0
    func load()
    {
        database.setUp()
        currentOffset = round(database.getOffsetAmount() / 0.1) * 0.1
        currentEmission = round(database.getEmission() / 0.1) * 0.1
        COTwoDataTXT.text = "\(currentEmission)"
        
        let treeAmount = database.getTrees()
        TreeDataTXT.text = treeAmount.description
        
        setChartValues()
        
        getAchievements()
    }
    
    var achievements : [String] = []
    var achievementTargets : [Int] = []
    func getAchievements()
    {
        let collRef : Query = Firestore.firestore().collection("achievements").order(by: "target")
        
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.achievements.append(result["name"] as? String ?? "error")
                self.achievementTargets.append(result["target"] as? Int ?? 0)
                
            }
        }
            self.achievementsTV.reloadData()
        }
    }
    
    func setChartValues()
    {
        
        let recordedEmissions = database.getAllEmissions()
        
        let values = (0 ..< recordedEmissions.count).map{(i) -> ChartDataEntry in
            let yValue = recordedEmissions[i]
            return ChartDataEntry(x: Double(i), y: Double(yValue))}
        
        let emissionSet = LineChartDataSet(entries: values, label: "cardon emissions")
        emissionSet.colors = [UIColor.white]
        emissionSet.drawCirclesEnabled = false
        emissionSet.drawFilledEnabled = true
        let lineColour = UIColor(red: 0.30, green: 0.62, blue: 0.23, alpha: 1.0);
        emissionSet.fillColor = lineColour
        emissionSet.fillAlpha = 0.8
        let data = LineChartData(dataSet: emissionSet)
        
        self.userPerformanceChart.data = data
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AchievementsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! AchievementsTableViewCell
        
        cell.nameTXT.text = achievements[indexPath.row]
        let progress : Float = self.currentOffset / Float(achievementTargets[indexPath.row])
        cell.progressPB.progress = progress
        
        
        cell.faceShareBTNPressed = {
            //print("facebook share button pressed")
            let shareAchievement = ShareHandler()
            shareAchievement.shareOnFacebook(achievement: self.achievements[indexPath.row])
            
            if (shareAchievement.post != nil)
            {
                self.present(shareAchievement.post!, animated: true, completion: nil)
            }
            else{
                self.present(shareAchievement.error!, animated: true, completion: nil)
            }
        }
        
       /* cell.facebookShareBTN.addTarget(self, action: Selector("subscribeTapped"), for: .touchUpInside)*/
        
        return cell
    }
    
    func subscribeTapped(){
     print("facebook button pressed")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }



}



