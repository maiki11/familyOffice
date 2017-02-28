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
   
    
    var date : String!
    var placeholders = ["Nombre", "Teléfono", "Dirección", "Fecha de Cumpleaños","", "RFC", "CURP", "NSS", "Tipo de sangre"]
    var aboutkeys = ["name", "phone",  "address","birthday","", "rfc", "curp", "nss", "bloodType"]
    var pickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -40)
        tableView.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
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
        cell.configure(text:  userDictionary.object(forKey: aboutkeys[indexPath.row]) as! String!, placeholder: placeholders[indexPath.row])
        return cell
    }
    
    //Private methods
    func setDate() -> Void {
        USER_SERVICE.user!.birthday = date
        userDictionary = USER_SERVICE.user!.toDictionary()
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
                    if(value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)==""){
                        ALERT_SERVICE.alertMessage(context: self, title: "Campo Vacío", msg: "El campo Nombre no puede quedar vacío")
                        ANIMATIONS.shakeTextField(txt: (cell?.myTextField)!)
                    }else{
                        USER_SERVICE.user!.name = value
                    }
                    break
                case "phone":
                    if(value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)==""){
                        ALERT_SERVICE.alertMessage(context: self, title: "Campo Vacío", msg: "El campo Teléfono no puede quedar vacío")
                        ANIMATIONS.shakeTextField(txt: (cell?.myTextField)!)
                    }else{
                        USER_SERVICE.user!.phone = value
                    }
                    break
                case "address":
                    USER_SERVICE.user!.address = value
                    break
                case "rfc":
                    USER_SERVICE.user!.rfc = value
                    break
                case "curp":
                    USER_SERVICE.user!.curp = value
                    break
                case "birthday":
                    USER_SERVICE.user!.birthday = value
                    break
                case "nss":
                    USER_SERVICE.user!.nss = value
                    break
                case "bloodType":
                    USER_SERVICE.user!.bloodtype = value
                    break
                default:
                    break
                }
            }
            index += 1
        }
        USER_SERVICE.updateUser(user: USER_SERVICE.user!)
        _ =  navigationController?.popViewController(animated: true)
        //UTILITY_SERVICE.gotoView(view: "ConfiguracionScene", context: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: true, context: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: false, context: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
