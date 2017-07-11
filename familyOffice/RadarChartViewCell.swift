//
//  RadarChartViewCell.swift
//  familyOffice
//
//  Created by Nan Montaño on 10/jul/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Charts

class RadarChartViewCell: UICollectionViewCell, ChartViewDelegate, IAxisValueFormatter, IValueFormatter {
    
    var selectedEntry : ChartDataEntry?
    var radarXAxisValues: [String] = []
    
    @IBOutlet weak var radarChart: RadarChartView!
    
    
    func config(){
        radarChart.delegate = self
        radarChart.rotationEnabled = false
        radarChart.yAxis.drawLabelsEnabled = false
        radarChart.yAxis.axisMinimum = 0
        radarChart.chartDescription?.enabled = false
        radarChart.xAxis.valueFormatter = self
        radarChart.legend.enabled = false
        
    }
    
    func setData(concepts: [BudgetConcept]){
        
        var data : [RadarChartDataEntry] = []
        radarXAxisValues = []
        
        concepts.forEach({
            if $0.amount >= 0 { return }
            if let index = radarXAxisValues.index(of: $0.name) {
                data[index].value += $0.amount
            } else {
                data.append(RadarChartDataEntry(value: -$0.amount))
                radarXAxisValues.append($0.name)
            }
        })
        
        let conceptsSet = RadarChartDataSet(values: data, label: nil)
        conceptsSet.drawFilledEnabled = true
        conceptsSet.fillColor = UIColor.cyan
        conceptsSet.fillAlpha = 0.3
        conceptsSet.valueFormatter = self
        
        radarChart.data = RadarChartData(dataSet: conceptsSet)
        radarChart.notifyDataSetChanged()
    }
    
    // MARK: ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedEntry = entry
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        selectedEntry = nil
    }
    
    // MARK: IAxisValueFormatter
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return radarXAxisValues[Int(value) % radarXAxisValues.count]
    }
    
    // MARK: IValueFormatter
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if(selectedEntry != entry) {
            return ""
        }
        let money = value as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: money)!
    }
    

    
}
