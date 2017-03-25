//
//  PersonalDataTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class PersonalDataTableViewController: UITableViewController {
    
<<<<<<< Updated upstream
    var userDictionary : NSDictionary!
=======
    var userDictionary = USER_SERVICE.user!.toDictionary()
    var user : User = USER_SERVICE.user!
>>>>>>> Stashed changes
    
    var date : String!
    var placeholders = ["Nombre", "Teléfono", "Dirección", "Fecha de Cumpleaños","", "RFC", "CURP", "NSS", "Tipo de sangre"]
    var aboutkeys = ["name", "phone",  "address","birthday","", "rfc", "curp", "nss", "bloodType"]
    var pickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< Updated upstream
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -40)
        tableView.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
=======
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
>>>>>>> Stashed changes
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Atras", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(save(sender:)))
        self.navigationItem.backBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = doneButton
        tableView.tableFooterView = UIView()

        //loadInfo()
    }
<<<<<<< Updated upstream
    override func viewWillAppear(_ animated: Bool) {
       userDictionary =  USER_SERVICE.users[0].toDictionary()

    }
    override func viewWillDisappear(_ animated: Bool) {
        userDictionary = [:]
    }
=======
    
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        cell.configure(text:  userDictionary.object(forKey: aboutkeys[indexPath.row]) as! String!, placeholder: placeholders[indexPath.row])
=======
        cell.configure(text:  userDictionary.object(forKey: aboutkeys[indexPath.row]) as! String!, placeholde: placeholders[indexPath.row])
>>>>>>> Stashed changes
        return cell
    }
    
    //Private methods
    func setDate() -> Void {
<<<<<<< Updated upstream
        USER_SERVICE.users[0].birthday = date
        userDictionary = USER_SERVICE.users[0].toDictionary()
=======
        user.birthday = date
        userDictionary = user.toDictionary()
>>>>>>> Stashed changes
        self.tableView.reloadData()
    }
    func save(sender: UINavigationBar) -> Void {
        var index = 0
        while index < aboutkeys.count {
            let indexPath = NSIndexPath(row: index, section: 0)
            if(index != 4){
                let cell: PersonalDataTableViewCell? = self.tableView.cellForRow(at: indexPath as IndexPath) as? PersonalDataTableViewCell
                let value = cell?.myTextField.text
<<<<<<< Updated upstream
                
                switch  aboutkeys[indexPath.row] {
                case "name":
                    if(value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)==""){
                        ALERT_SERVICE.alertMessage(context: self, title: "Campo Vacío", msg: "El campo Nombre no puede quedar vacío")
                        ANIMATIONS.shakeTextField(txt: (cell?.myTextField)!)
                    }else{
                        USER_SERVICE.users[0].name = value
                    }
                    break
                case "phone":
                    if(value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)==""){
                        ALERT_SERVICE.alertMessage(context: self, title: "Campo Vacío", msg: "El campo Teléfono no puede quedar vacío")
                        ANIMATIONS.shakeTextField(txt: (cell?.myTextField)!)
                    }else{
                        USER_SERVICE.users[0].phone = value
                    }
                    break
                case "address":
                    USER_SERVICE.users[0].address = value
                    break
                case "rfc":
                    USER_SERVICE.users[0].rfc = value
                    break
                case "curp":
                    USER_SERVICE.users[0].curp = value
                    break
                case "birthday":
                    USER_SERVICE.users[0].birthday = value
                    break
                case "nss":
                    USER_SERVICE.users[0].nss = value
                    break
                case "bloodType":
                    USER_SERVICE.users[0].bloodtype = value
=======
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
>>>>>>> Stashed changes
                    break
                default:
                    break
                }
            }
            index += 1
        }
<<<<<<< Updated upstream
        USER_SERVICE.updateUser(user: USER_SERVICE.users[0])
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
=======
        USER_SERVICE.updateUser(user: user)
    }
    
>>>>>>> Stashed changes
    
}
