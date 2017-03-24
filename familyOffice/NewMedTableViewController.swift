//
//  NewMedTableViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 16/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class NewMedTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var medDosePicker: UIPickerView!
    @IBOutlet weak var medTypeView: UISegmentedControl!
    @IBOutlet weak var medNameView: UITextField!
    
    var pickerSelection = [0,0,0,0,0]
    var med : NSDictionary?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let saveButton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(save(button:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        medDosePicker.dataSource = self
        medDosePicker.delegate = self
        
        if let m = med {
            medNameView.text = m["name"] as? String
            medTypeView.selectedSegmentIndex = ["pill": 0, "shot": 1, "drinkable": 2][m["type"] as! String]!
            let dose = m["dose"] as! String
            let endIndexMinusOne = dose.index(before: dose.endIndex)
            if dose[endIndexMinusOne] == "m" {
                let doseMg = Int(dose.substring(to: endIndexMinusOne))
                medDosePicker.selectRow(doseMg!-1, inComponent: 0, animated: false)
                medDosePicker.selectRow(0, inComponent: 1, animated: false)
            }else{
                medDosePicker.selectRow(Int(dose)!, inComponent: 0, animated: false)
                medDosePicker.selectRow(1, inComponent: 1, animated: false)
            }
            var lapse = m["lapse"] as! Int, timeUnit = 0
            if lapse > 60 { // mas de 60 minutos
                lapse /= 60
                timeUnit += 1
                if lapse > 24 { // mas de 24 horas
                    lapse /= 24
                    timeUnit += 1
                    if lapse > 30 { // mas de 30 dias
                        lapse /= 30
                        timeUnit += 1
                    }
                }
            }
            medDosePicker.selectRow(lapse-1, inComponent: 3, animated: false)
            medDosePicker.selectRow(timeUnit, inComponent: 4, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return 1000
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 60
        case 4:
            return 4
        default:
            return 0
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row+1)"
        case 1:
            return ["mg/ml", "dosis"][row]
        case 2:
            return "cada"
        case 3:
            return "\(row+1)"
        case 4:
            return ["minutos", "horas", "dias", "meses"][row]
        default:
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection[component] = row
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save(button: UIBarButtonItem){
        
        let medName = medNameView.text
        
        let medType = ["pill", "shot", "drinkable"][medTypeView.selectedSegmentIndex]
        
        var medDose = "\(pickerSelection[0] + 1)"
        if pickerSelection[1] == 0 {
            medDose += "m"
        }
        
		var minutes = pickerSelection[3] + 1
        switch pickerSelection[4] {
        case 1: //horas
            minutes *= 60
            break
        case 2: //diaas
            minutes *= 60*24
            break
        case 3: //meses
            minutes *= 60*24*30
            break
        default: break
        }
        let medLapse = minutes
        
        
        let med : NSDictionary = [
            Health.Med.kMedName: medName!,
            Health.Med.kMedType: medType,
            Health.Med.kMedDose: medDose,
            Health.Med.kMedLapse: medLapse
        ]
        
        var user = USER_SERVICE.users[0]
        if let health = user.health! as NSDictionary? {
            var meds = health[Health.kHealthMeds] as? [NSDictionary] ?? []
            if let i = index {
                meds[i] = med
            }else {
                meds.append(med)
            }
            health.setValue(meds, forKey: Health.kHealthMeds) 
            user.health = health
        }else{
            user.health = [
                Health.kHealthMeds: [med]
            ]
            
        }
        
        USER_SERVICE.updateUser(user: user)
        // TODO: goback
        self.navigationController!.popViewController(animated: false)
    }

}
