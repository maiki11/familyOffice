//
//  PersonalDataTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class PersonalDataTableViewController: UITableViewController {
    
    var userDictionary : NSDictionary!
    
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
    override func viewWillAppear(_ animated: Bool) {
       userDictionary =  Constants.Services.USER_SERVICE.users[0].toDictionary()

    }
    override func viewWillDisappear(_ animated: Bool) {
        userDictionary = [:]
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
        Constants.Services.USER_SERVICE.users[0].birthday = date
        userDictionary = Constants.Services.USER_SERVICE.users[0].toDictionary()
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
                        Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Campo Vacío", msg: "El campo Nombre no puede quedar vacío")
                        Constants.Services.ANIMATIONS.shakeTextField(txt: (cell?.myTextField)!)
                    }else{
                        Constants.Services.USER_SERVICE.users[0].name = value
                    }
                    break
                case "phone":
                    if(value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)==""){
                        Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Campo Vacío", msg: "El campo Teléfono no puede quedar vacío")
                        Constants.Services.ANIMATIONS.shakeTextField(txt: (cell?.myTextField)!)
                    }else{
                        Constants.Services.USER_SERVICE.users[0].phone = value
                    }
                    break
                case "address":
                    Constants.Services.USER_SERVICE.users[0].address = value
                    break
                case "rfc":
                    Constants.Services.USER_SERVICE.users[0].rfc = value
                    break
                case "curp":
                    Constants.Services.USER_SERVICE.users[0].curp = value
                    break
                case "birthday":
                    Constants.Services.USER_SERVICE.users[0].birthday = value
                    break
                case "nss":
                    Constants.Services.USER_SERVICE.users[0].nss = value
                    break
                case "bloodType":
                    Constants.Services.USER_SERVICE.users[0].bloodtype = value
                    break
                default:
                    break
                }
            }
            index += 1
        }
        Constants.Services.USER_SERVICE.updateUser(user: Constants.Services.USER_SERVICE.users[0])
        _ =  navigationController?.popViewController(animated: true)
        //UTILITY_SERVICE.gotoView(view: "ConfiguracionScene", context: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Constants.Services.UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: true, context: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Constants.Services.UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: false, context: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
