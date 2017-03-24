//
//  NewDoctorViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 23/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class NewDoctorViewController: UIViewController {

    @IBOutlet weak var doctorName: UITextField!
    @IBOutlet weak var doctorAddress: UITextField!
    @IBOutlet weak var doctorPhone: UITextField!
    
    var editDoctor : Health.Doctor?
    var editIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(save(sender:)))
		self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
        
        if let doc = editDoctor {
            doctorName.text = doc.name
            doctorAddress.text = doc.address
            doctorPhone.text = doc.phone
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var user = USER_SERVICE.users[0]
        var health = Health(health: user.health ?? [:])
        
        var emptyText: UITextField?
        if let docName = doctorName.text, let docPhone = doctorPhone.text, let docAddress = doctorAddress.text {
            
            if docName.characters.count == 0 {
                emptyText = doctorName
            }else if docAddress.characters.count == 0 {
                emptyText = doctorAddress
            }else if docPhone.characters.count != 10 || Int(docPhone) == nil {
                emptyText = doctorPhone
            }else if var doc = editDoctor {
                
                doc.name = docName
                doc.phone = docPhone
                doc.address = docAddress
                
                health.doctors[editIndex!] = doc.toDictionary()
                user.health = health.toDictionary()
                USER_SERVICE.updateUser(user: user)
                self.navigationController!.popViewController(animated: true)
                
            } else {
                let doc = Health.Doctor(name: docName, phone: docPhone, address: docAddress)
                health.doctors.append(doc.toDictionary())
                user.health = health.toDictionary()
                USER_SERVICE.updateUser(user: user)
                self.navigationController!.popViewController(animated: true)
            }
            
        }else{
            if doctorName.text == nil {
                emptyText = doctorName
            }else if doctorPhone.text == nil {
                emptyText = doctorPhone
            } else {
                emptyText = doctorAddress
            }
        }
        
        if let shakingTextField = emptyText {
            ANIMATIONS.shakeTextField(txt: shakingTextField)
        }
        
        
    }

}
