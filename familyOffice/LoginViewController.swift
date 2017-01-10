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

class ViewController: UIViewController, GIDSignInUIDelegate{
    
    let auth = AuthService.authService

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if (user != nil) {
                Utility.Instance().gotoView(view: "TabBarControllerView", context: self)
            }
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
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
<<<<<<< HEAD
        Utility.Instance().gotoView(view: "SignUpView", context: self)
=======
        gotoView(view: "SignUpView")
        
    }
    func gotoView(view:String )  {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: view)
        self.present(homeViewController, animated: true, completion: nil)
>>>>>>> master
    }
    
}

