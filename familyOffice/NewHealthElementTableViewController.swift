//
//  NewHealthElementTableViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 07/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class NewHealthElementViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    var healthType : Int = -1
    var healthIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let saveButton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(save(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        if let index = healthIndex {
            let med = Constants.Services.USER_SERVICE.users[0].health.elements[index]
            nameField.text = med.name
            descriptionField.text = med.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return healthType == Health.Element.typeOperation ? "Tipo de operación" :"Nombre"
        }
        switch healthType {
        case Health.Element.typeMed:
            return "Instrucciones"
        case Health.Element.typeDisease:
            return "Síntomas, tratamiento"
        case Health.Element.typeDoctor:
            return "Horario, teléfono, dirección"
        case Health.Element.typeOperation:
            return "Fecha, tratamiento"
        default: return nil
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
    
    func save(sender: UIBarButtonItem){
        let name : String! = nameField.text
        if name == nil || name.isEmpty {
        	Constants.Services.ANIMATIONS.shakeTextField(txt: nameField)
            return
        }
        
        let description : String! = descriptionField.text
        if description == nil || description.isEmpty {
            Constants.Services.ANIMATIONS.shakeTextField(txt: descriptionField)
            return
        }
        
        let element = Health.Element(name: name, type: healthType, description: description)
        var user = Constants.Services.USER_SERVICE.users[0]
        if let index = healthIndex {
            user.health.elements[index] = element
        } else {
            user.health.elements.append(element)
        }
        Constants.Services.USER_SERVICE.updateUser(user: user)
        navigationController!.popViewController(animated: true)
        
    }

}
