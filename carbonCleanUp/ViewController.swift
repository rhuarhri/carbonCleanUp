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

class ViewController: UIViewController {

    @IBOutlet weak var userPerformanceChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userPerformanceChart.chartDescription?.text = "description"
        userPerformanceChart.gridBackgroundColor = UIColor.white
        
        let ll = ChartLimitLine(limit: 10.0, label: "Average")
        userPerformanceChart.rightAxis.addLimitLine(ll)
        
        setChartValues()
    }
    
    func setChartValues(count : Int = 20)
    {
        
        let values = (0 ..< count).map{(i) -> ChartDataEntry in
            let val = Double(i)//Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(entries: values, label: "dataset1")
        set1.colors = [UIColor.white]
        let data = LineChartData(dataSet: set1)
        
        self.userPerformanceChart.data = data
    }


}

