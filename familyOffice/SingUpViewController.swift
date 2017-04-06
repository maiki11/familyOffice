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
import GoogleSignIn

class SingUpViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var nameTxtfield: UITextField!
    @IBOutlet weak var emailTxtfield: UITextField!
    @IBOutlet weak var phoneTxtfield: UITextField!
    @IBOutlet weak var passwordTxtfield: UITextField!
    @IBOutlet weak var confirmPassTxtfield: UITextField!
  
    
    override func viewDidLoad() {
        //AUTH_SERVICE.isAuth(view: self.self, name:"TabBarControllerView")
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
        let backButton : UIBarButtonItem = UIBarButtonItem(title: "Atrás", style: UIBarButtonItemStyle.plain, target: self, action:#selector(handleBack))
        self.navigationItem.leftBarButtonItem = backButton
        self.confirmPassTxtfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Registrar"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        STYLES.borderbottom(textField: self.nameTxtfield, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        STYLES.borderbottom(textField: self.emailTxtfield, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        STYLES.borderbottom(textField: self.phoneTxtfield, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        STYLES.borderbottom(textField: self.passwordTxtfield, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        STYLES.borderbottom(textField: self.confirmPassTxtfield, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func handleSingUp(_ sender: UIButton) {
        var er: String?
        if(nameTxtfield.text==""){
            er = "Nombre debe ser capturado"
            ANIMATIONS.shakeTextField(txt: nameTxtfield)
        }else{
            if(emailTxtfield.text==""){
                er = "Correo electrónico debe ser capturado"
                ANIMATIONS.shakeTextField(txt: emailTxtfield)
            }else{
                if(phoneTxtfield.text==""){
                    er = "Celular debe ser capturado"
                    ANIMATIONS.shakeTextField(txt: phoneTxtfield)
                }else{
                    if(passwordTxtfield.text=="" || confirmPassTxtfield.text==""){
                        er = "La contraseña y confirmación de contraseña deben ser capturadas"
                        ANIMATIONS.shakeTextField(txt: passwordTxtfield)
                        ANIMATIONS.shakeTextField(txt: confirmPassTxtfield)
                    }else{
                        if(passwordTxtfield.text! == confirmPassTxtfield.text!){
                            FIRAuth.auth()?.createUser(withEmail: emailTxtfield.text!, password: passwordTxtfield.text!) { (user, error) in
                                if(error == nil){
                                    self.createAccount(uid: (user?.uid)!)
                                }
                                else{
                                    let errCode : FIRAuthErrorCode = FIRAuthErrorCode(rawValue: error!._code)!
                                        switch errCode {
                                        case .errorCodeInvalidEmail:
                                            er = "Correo electrónico incorrecto"
                                        case .errorCodeWrongPassword:
                                            er = "Contraseña incorrecta"
                                        case .errorCodeWeakPassword:
                                            er = "La contraseña debe de contener al menos 6 caracteres"
                                        default:
                                            er = "Algo salio mal, intente más tarde"
                                        }
                                }
                               
                            }
                        }else{
                            er = "Las contraseñas deben de coincidir"
                            ANIMATIONS.shakeTextField(txt: passwordTxtfield)
                            ANIMATIONS.shakeTextField(txt: confirmPassTxtfield)
                        }
                    }
                }
            }
        }
        if(er != nil ){
            let alert = UIAlertController(title: "Verifica tus datos", message: er, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func handleBack() {
        UTILITY_SERVICE.gotoView(view: "StartView", context: self)
    }
  
    func createAccount(uid: String){
        let userModel = ["name" : self.nameTxtfield.text!,
                         "phone": self.phoneTxtfield.text!]
        REF_USERS.child(uid).setValue(userModel)
        UTILITY_SERVICE.gotoView(view: "StartView", context: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func googlePlusTouchUpInside(sender: AnyObject){
        GIDSignIn.sharedInstance().signIn()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -200, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -200, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}
