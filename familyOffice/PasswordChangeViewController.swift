//
//  PasswordChangeViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatPass: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    override func viewDidLoad() {
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Atras", style: .plain, target: self, action: #selector(back(sender:)))
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Cambiar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(changePassword(sender:)))
        
        self.navigationItem.backBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = doneButton
        super.viewDidLoad()
        STYLES.borderbottom(textField: oldPassword, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        STYLES.borderbottom(textField: newPassword, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        STYLES.borderbottom(textField: repeatPass, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        self.viewContainer.layer.borderWidth = 1
        self.viewContainer.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.viewContainer.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName:  Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
              Constants.Services.UTILITY_SERVICE.stopLoading(view: self.view)
        }
        NotificationCenter.default.addObserver(forName:  Constants.NotificationCenter.ERROR_NOTIFICATION, object: nil, queue: nil){_ in
              Constants.Services.UTILITY_SERVICE.stopLoading(view: self.view)
           
        }
        
    }
    
    @IBAction func savePassword(_ sender: Any) {
        changePassword(sender: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver( Constants.NotificationCenter.SUCCESS_NOTIFICATION)
        NotificationCenter.default.removeObserver( Constants.NotificationCenter.ERROR_NOTIFICATION)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back(sender: UIBarButtonItem) -> Void {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    func changePassword(sender: UIBarButtonItem?) -> Void {
        Constants.Services.UTILITY_SERVICE.loading(view: self.view)
        if(oldPassword.text! == ""){
             Constants.Services.ANIMATIONS.shakeTextField(txt: oldPassword)
             Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Campo vacío", msg: "El campo Contraseña actual no puede estar vacío")
        }else{
            if(newPassword.text == ""){
                 Constants.Services.ANIMATIONS.shakeTextField(txt: newPassword)
                Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Campo vacío", msg: "El campo Contraseña nueva no puede estar vacío")
            }else{
                if((newPassword.text?.characters.count)! < 6){
                     Constants.Services.ANIMATIONS.shakeTextField(txt: newPassword)
                     Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Mínimo de caracteres", msg: "El campo Contraseña nueva tiene que tener al menos 6 caracteres")
                }else{
                    if(repeatPass.text == ""){
                         Constants.Services.ANIMATIONS.shakeTextField(txt: repeatPass)
                         Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Campo vacío", msg: "El campo Repetir contraseña no puede estar vacío")
                    }else{
                        if((repeatPass.text?.characters.count)! < 6){
                             Constants.Services.ANIMATIONS.shakeTextField(txt: repeatPass)
                             Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Mínimo de caracteres", msg: "El campo Confirmar contraseña tiene que tener al menos 6 caracteres")
                        }else{
                            if(newPassword.text == repeatPass.text ){
                                Constants.Services.USER_SERVICE.changePassword(oldPass: oldPassword.text!, newPass: newPassword.text!, context: self)
                            }else{
                                 Constants.Services.ANIMATIONS.shakeTextField(txt: newPassword)
                                 Constants.Services.ANIMATIONS.shakeTextField(txt: repeatPass)
                                 Constants.Services.ALERT_SERVICE.alertMessage(context: self, title: "Contraseña distinta", msg: "La contraseña nueva y  confirmar contraseña no coinciden")
                            }
                        }
                    }
                }
            }
        }
         Constants.Services.UTILITY_SERVICE.stopLoading(view: self.view)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         Constants.Services.UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: true, context: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         Constants.Services.UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: false, context: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
