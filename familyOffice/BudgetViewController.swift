//
//  BudgetViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 28/jun/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Charts

class BudgetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var values: [BudgetConcept] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // datos inventados
        let conceptNames = ["Comida", "Transporte", "Alojamiento", "Entretenimiento", "Hogar", "Otros"]
        let year2017 = Date(string: "01 01 2017", formatter: DateFormatter.dayMonthAndYear)!
        let almostAYear : UInt32 = 60*60*24*364
        for _ in 0..<100 {
            values.append(BudgetConcept(
                name: conceptNames[Int(arc4random_uniform(UInt32(conceptNames.count)))],
                amount: Double(arc4random_uniform(10000)) - 5000,
                date: Date(timeInterval: TimeInterval(arc4random_uniform(almostAYear)), since: year2017)
            ))
        }
        values.sort(by: {(a, b) in a.date < b.date})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Aqui se leerian los datos de firebase para despues
        // construir los datos y llamar las funciones setData,
        // ademas de los valores para radarXAxisValues

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3+values.count // lineChart + radarChart + tableHeaders + values
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(section){
        case 0, 1: return 1
        default: return 3
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! BudgetCollectionHeaderView
        switch(indexPath.section){
        case 0: header.label.text = "Gráfica de tendencias"; break
        case 1: header.label.text = "Egresos por concepto"; break
        case 2: header.label.text = "Tabla de conceptos"; break
        default: break
        }
        header.label.layer.borderWidth = 1
        header.label.layer.cornerRadius = 5
        header.label.layer.masksToBounds = true
        header.label.layer.borderColor = UIColor.lightGray.cgColor
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: section < 3 ? 50 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch(indexPath.section){
        case 0: return CGSize(width: 343, height: 309)
        case 1: return CGSize(width: 343, height: 309)
        default: return CGSize(width: 125, height: 32)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch(indexPath.section){
        case 0: /* lineChart */
            let lineChartCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "lineChartCell", for: indexPath) as! LineChartViewCell
            lineChartCell.config()
            lineChartCell.setData(concepts: values, initialBudget: Double(arc4random_uniform(30000)))
            return lineChartCell
            
        case 1: /* radarChart */
            let radarChartCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "radarChartCell", for: indexPath) as! RadarChartViewCell
            radarChartCell.config()
            radarChartCell.setData(concepts: values)
            return radarChartCell
            
        case 2: /* tableHeaders */
            let tableHeader = collectionView
                .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BudgetCollectionViewCell
            tableHeader.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            switch(indexPath.row){
            case 0: tableHeader.label.text = "Concepto"; break
            case 1: tableHeader.label.text = "Cantidad"; break
            case 2: tableHeader.label.text = "Fecha"; break
            default: break
            }
            return tableHeader
            
        default: /* values */
            let index = indexPath.section - 3
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BudgetCollectionViewCell
            cell.backgroundColor = values[index].amount > 0
                ? UIColor(red: 0, green: 1, blue: 0, alpha: 0.1)
                : UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
            switch(indexPath.row){
            case 0: cell.label.text = values[index].name; break
            case 1:
                let money = values[index].amount as NSNumber
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "es_MX")
                cell.label.text = formatter.string(from: money)!;
                break
            case 2: cell.label.text = values[index].date.string(with: DateFormatter.dayMonthAndYear2)
            default: break
            }
            return cell
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func setValues(){
//        radarXAxisValues = ["Comida", "Transporte", "Alojamiento", "Entretenimiento", "Hogar", "Otros"]
//        var currentBudget = Double(arc4random_uniform(30000))
//        var budget: [ChartDataEntry] = [ChartDataEntry(x: 0, y: currentBudget)]
//        var income: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 0)]
//        var discharges: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 0)]
//        var conceptValues: [Double] = [0,0,0,0,0,0]
//        for i in 1 ..< 12 {
//            let _in : Double = Double(arc4random_uniform(10000))
//            let _out: Double = Double(arc4random_uniform(10000))
//            income.append(ChartDataEntry(x: Double(i), y: _in))
//            discharges.append(ChartDataEntry(x: Double(i), y: _out))
//            
//            let conceptIndex : Int = i%6
//            conceptValues[conceptIndex] += _out
//            
//            currentBudget += _in - _out
//            budget.append(ChartDataEntry(x: Double(i), y: currentBudget))
//            
//        }
//        
//        var concepts: [RadarChartDataEntry] = []
//        for i in 0 ..< conceptValues.count {
//            let val = conceptValues[i]
//            concepts.append(RadarChartDataEntry(value: val))
//        }
//        print("asdbakjsbdkjasbd", concepts);
//        setData(lineChart: lineChart, budget: budget, income: income, discharges: discharges)
//        setData(radarChart: radarChart, concepts: concepts)
//    }
    
    
}
