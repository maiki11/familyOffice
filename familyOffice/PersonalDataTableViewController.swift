//
//  PersonalDataTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class PersonalDataTableViewController: UITableViewController {
    
    var userDictionary = USER_SERVICE.user!.toDictionary()
    var user : User = USER_SERVICE.user!
    
    var date : String!
    var placeholders = ["Nombre", "Teléfono", "Dirección", "Fecha de Cumpleaños","", "RFC", "CURP", "NSS", "Tipo de sangre"]
    var aboutkeys = ["name", "phone",  "address","birthday","", "rfc", "curp", "nss", "bloodType"]
    var pickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Atras", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(save(sender:)))
        self.navigationItem.backBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = doneButton
        tableView.tableFooterView = UIView()

        //loadInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func back(sender: UIBarButtonItem) -> Void {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aboutkeys.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            pickerVisible = !pickerVisible
            tableView.reloadData()
        }else{
            pickerVisible = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            if pickerVisible == false {
                return 0.0
            }
            return 165.0
        }
        return 44.0
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        date = dateFormatter.string(from: sender.date)
        setDate()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "datepickerCell", for: indexPath) as! DatePickerTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonalDataTableViewCell
        if(indexPath.row == 3){
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.myTextField.isEnabled = false
        }
        cell.configure(text:  userDictionary.object(forKey: aboutkeys[indexPath.row]) as! String!, placeholde: placeholders[indexPath.row])
        return cell
    }
    
    //Private methods
    func setDate() -> Void {
        user.birthday = date
        userDictionary = user.toDictionary()
        self.tableView.reloadData()
    }
    func save(sender: UINavigationBar) -> Void {
        var index = 0
        while index < aboutkeys.count {
            let indexPath = NSIndexPath(row: index, section: 0)
            if(index != 4){
                let cell: PersonalDataTableViewCell? = self.tableView.cellForRow(at: indexPath as IndexPath) as? PersonalDataTableViewCell
                let value = cell?.myTextField.text
                switch  aboutkeys[indexPath.row] {
                case "name":
                    user.name = value
                    break
                case "phone":
                    user.phone = value
                    break
                case "address":
                    user.address = value
                    break
                case "rfc":
                    user.rfc = value
                    break
                case "curp":
                    user.curp = value
                    break
                case "birthday":
                    user.birthday = value
                    break
                case "nss":
                    user.nss = value
                    break
                case "bloodType":
                    user.bloodtype = value
                    break
                default:
                    break
                }
            }
            index += 1
        }
        USER_SERVICE.updateUser(user: user)
    }
    
    
}
