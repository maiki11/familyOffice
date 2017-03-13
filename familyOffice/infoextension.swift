//
//  infoextension.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 13/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

extension ProfileUserViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return aboutkeys.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonalDataTableViewCell
        cell.myTextField.isEnabled = false
        cell.configure(text:  userDic.object(forKey: aboutkeys[indexPath.row]) as! String!, placeholder: placeholders[indexPath.row])
        return cell
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
