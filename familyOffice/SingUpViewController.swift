//
//  SingUpViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SingUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxtfield: UITextField!
    @IBOutlet weak var emailTxtfield: UITextField!
    @IBOutlet weak var phoneTxtfield: UITextField!
    @IBOutlet weak var passwordTxtfield: UITextField!
    @IBOutlet weak var confirmPassTxtfield: UITextField!
    
    let ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.confirmPassTxtfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func handleSingUp(_ sender: UIButton) {
        if(passwordTxtfield.text! == confirmPassTxtfield.text!){
            FIRAuth.auth()?.createUser(withEmail: emailTxtfield.text!, password: passwordTxtfield.text!) { (user, error) in
                if(error != nil){
                    print("Algo salio mal!!")
                }else{
                    self.createAccount(uid: (user?.uid)!)
                }
            }
        }
    }
    @IBAction func handleBack(_ sender: UIButton) {
        Utility.Instance().gotoView(view: "StartView", context: self)
    }
  
    func createAccount(uid: String){
        let userModel = ["name" : self.nameTxtfield.text!,
                         "phone": self.phoneTxtfield.text!]
        self.ref.child("users").child(uid).setValue(userModel)
        Utility.Instance().gotoView(view: "StartView", context: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
