//
//  ViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class ViewController: UIViewController, GIDSignInUIDelegate{
    
    let auth = AuthService.authService

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        AuthService.authService.isAuth(view: self.self, name: "TabBarControllerView")
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleSignIn(_ sender: UIButton) {
        if(!(emailTextfield.text?.isEmpty)! && !(passwordTextfield.text?.isEmpty)!){
            auth.login(email: emailTextfield.text!, password: passwordTextfield.text!)
        }
    }
    
   
  
    @IBAction func handleSignUp(_ sender: UIButton) {

        Utility.Instance().gotoView(view: "SignUpView", context: self)
    }
    
}

