//
//  ViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate{
    
    let auth = AuthService.authService

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
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
            if !auth.login(email: emailTextfield.text!, password: passwordTextfield.text!)  {
                print("Log in")
                gotoView(view: "TabBarControllerView")
            }else{
                print("hubo un error")
            }
        }    
    }
  
    @IBAction func handleSignUp(_ sender: UIButton) {
        gotoView(view: "SignUpView")
        
    }
    func gotoView(view:String )  {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: view)
        self.present(homeViewController, animated: true, completion: nil)
    }
}

