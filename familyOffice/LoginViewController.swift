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
import AVFoundation


class ViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate, UISearchBarDelegate{
    
    let auth = AuthService.authService
    @IBOutlet var background: UIImageView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet var emailButton: UITextField!
    
    override func viewDidLoad() {
        self.auth.isAuth(view: self.self, name: "TabBarControllerView")
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

