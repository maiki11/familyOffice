//
//  BudgetViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 28/jun/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Charts

class BudgetViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter, IValueFormatter {

    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var radarChart: RadarChartView!
    var selectedEntry : ChartDataEntry?
    var radarXAxisValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configLineChart()
        configRadarChart()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Aqui se leerian los datos de firebase para despues
        // construir los datos y llamar las funciones setData,
        // ademas de los valores para radarXAxisValues
        radarXAxisValues = ["Comida", "Transporte", "Alojamiento", "Entretenimiento", "Hogar", "Otros"]
        var currentBudget = Double(arc4random_uniform(30000))
        var budget: [ChartDataEntry] = [ChartDataEntry(x: 0, y: currentBudget)]
        var income: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 0)]
        var discharges: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 0)]
        var conceptValues: [Double] = [0,0,0,0,0,0]
        for i in 1 ..< 12 {
            let _in : Double = Double(arc4random_uniform(10000))
            let _out: Double = Double(arc4random_uniform(10000))
            income.append(ChartDataEntry(x: Double(i), y: _in))
            discharges.append(ChartDataEntry(x: Double(i), y: _out))
            
            let conceptIndex : Int = i%6
            conceptValues[conceptIndex] += _out
            
            currentBudget += _in - _out
            budget.append(ChartDataEntry(x: Double(i), y: currentBudget))
            
        }
        
        var concepts: [RadarChartDataEntry] = []
        for i in 0 ..< conceptValues.count {
            let val = conceptValues[i]
            concepts.append(RadarChartDataEntry(value: val))
        }
        print("asdbakjsbdkjasbd", concepts);
        setData(lineChart: lineChart, budget: budget, income: income, discharges: discharges)
        setData(radarChart: radarChart, concepts: concepts)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Charts
    
    func configLineChart(){
        lineChart.delegate = self
        lineChart.dragEnabled = true
        lineChart.pinchZoomEnabled = true
        lineChart.drawGridBackgroundEnabled = true
        lineChart.gridBackgroundColor = UIColor.white
        lineChart.chartDescription?.enabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.xAxis.valueFormatter = self
        lineChart.xAxis.granularity = 1
        lineChart.leftAxis.valueFormatter = self
        lineChart.rightAxis.enabled = false
    }
    
    func configRadarChart(){
        radarChart.delegate = self
//        radarChart.rotationEnabled = false
        radarChart.yAxis.drawLabelsEnabled = false
        radarChart.yAxis.axisMinimum = 0
        radarChart.chartDescription?.enabled = false
        radarChart.xAxis.valueFormatter = self
        radarChart.legend.enabled = false
        
    }
    
    func setData(lineChart: LineChartView, budget: [ChartDataEntry], income: [ChartDataEntry], discharges: [ChartDataEntry]){
        let budgetSet = LineChartDataSet(values: budget, label: "Presupuesto")
        let incomeSet = LineChartDataSet(values: income, label: "Ingresos")
        let dischargesSet = LineChartDataSet(values: discharges, label: "Egresos")
        
        let font = UIFont.systemFont(ofSize: 12)
        
        budgetSet.setColor(UIColor.cyan)
        budgetSet.circleColors = [UIColor.cyan]
        budgetSet.mode = .horizontalBezier
        budgetSet.valueFormatter = self
        budgetSet.drawFilledEnabled = true
        budgetSet.fillColor = UIColor.cyan
        budgetSet.fillAlpha = 0.3
        budgetSet.valueFont = font
        
        let green = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        incomeSet.setColor(green)
        incomeSet.circleColors = [green]
        incomeSet.mode = .horizontalBezier
        incomeSet.valueFormatter = self
        incomeSet.valueFont = font
        
        dischargesSet.setColor(UIColor.red)
        dischargesSet.circleColors = [UIColor.red]
        dischargesSet.mode = .horizontalBezier
        dischargesSet.valueFormatter = self
        dischargesSet.valueFont = font
        
        lineChart.data = LineChartData(dataSets: [budgetSet, incomeSet, dischargesSet])
    }
    
    func setData(radarChart: RadarChartView, concepts: [RadarChartDataEntry]){
        
        let conceptsSet = RadarChartDataSet(values: concepts, label: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IAxisValueFormatter
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if(radarChart.xAxis == axis){
        	return radarXAxisValues[Int(value) % radarXAxisValues.count]
        }
        if(lineChart.xAxis == axis){
            return ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago",
                    "Sep", "Oct", "Nov", "Dic"][Int(value) % 12]
        }
        if(lineChart.leftAxis == axis){
            let money = value as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "es_MX")
            return formatter.string(from: money)!
        }
        return "wut"
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
