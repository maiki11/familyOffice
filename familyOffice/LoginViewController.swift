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
import AVFoundation
//JVFloatLabeledText/JVFloatLabeledText.h"
//#import "JVFloatLabeledText/JVFloatLabeledText.h"


class ViewController: UIViewController, GIDSignInUIDelegate{
    
    let auth = AuthService.authService
    @IBOutlet var background: UIImageView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet var emailButton: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if (user != nil) {
                Utility.Instance().gotoView(view: "TabBarControllerView", context: self)
            }
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleSignIn(_ sender: UIButton) {
        if(!(emailTextfield.text?.isEmpty)! && !(passwordTextfield.text?.isEmpty)!){
            if !auth.login(email: emailTextfield.text!, password: passwordTextfield.text!)  {
                print("Log in")
                Utility.Instance().gotoView(view: "TabBarControllerView", context: self)
            }else{
                print("hubo un error")
            }
        }    
    }
  
    @IBAction func handleSignUp(_ sender: UIButton) {

        Utility.Instance().gotoView(view: "SignUpView", context: self)

        
    }
    
}

