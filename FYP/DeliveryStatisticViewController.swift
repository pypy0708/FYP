//
//  DeliveryStatisticViewController.swift
//  FYP
//
//  Created by yoshi on 22/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class DeliveryStatisticViewController: UIViewController {
    
    @IBOutlet weak var chart: BarChartView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var revenue: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadChart()
    }
   
    func loadChart() {
        

        chart.noDataText = "There Is No Data"
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        chart.xAxis.labelPosition = .bottom
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.days)
        
        APIManager.shared.getRevenue { (json) in
            
            if json != nil {
                
                let revenue = json?["revenue"]
                var max: Double = 0
              
                var dataEntries: [BarChartDataEntry] = []
                
                for i in 0..<self.days.count {
                    let day = self.days[i]
                    if (revenue?[day].double)! > max {
                        max = (revenue?[day].double)!
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(i), y: (revenue?[day].double!)!)
                    
                    dataEntries.append(dataEntry)
                }
                let Ymax = self.roundUp(max, toNearest: 100.0)
                print(Ymax)
                self.chart.leftAxis.axisMinimum = 0.0
                self.chart.leftAxis.axisMaximum = Ymax
                let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue by day")
                let chartData = BarChartData(dataSet: chartDataSet)
                let purple = ChartColorTemplates.colorFromString("rgba(113,46,158,1.0)")
                let blue =  ChartColorTemplates.colorFromString("rgba(101,108,235,1.0)")
                chartDataSet.colors = ChartColorTemplates.colorful() + [purple] + [blue]
                self.chart.data = chartData
         
            }
            
        }
    }
    func roundUp(_ value: Double, toNearest: Double) -> Double {
      return ceil(value / toNearest) * toNearest
    }
}

