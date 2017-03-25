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
    
    override func viewDidLoad() {
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Atras", style: .plain, target: self, action: #selector(back(sender:)))
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Cambiar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(changePassword(sender:)))
        
        self.navigationItem.backBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = doneButton
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
             UTILITY_SERVICE.stopLoading(view: self.view)
        }
        NotificationCenter.default.addObserver(forName: ERROR_NOTIFICATION, object: nil, queue: nil){_ in
             UTILITY_SERVICE.stopLoading(view: self.view)
           
        }
        
    }
    
    @IBAction func savePassword(_ sender: Any) {
        changePassword(sender: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(SUCCESS_NOTIFICATION)
        NotificationCenter.default.removeObserver(ERROR_NOTIFICATION)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back(sender: UIBarButtonItem) -> Void {
        _ =  navigationController?.popViewController(animated: true)
    }
    
    func changePassword(sender: UIBarButtonItem?) -> Void {
        UTILITY_SERVICE.loading(view: self.view)
<<<<<<< Updated upstream
        if(oldPassword.text! == ""){
            ANIMATIONS.shakeTextField(txt: oldPassword)
            ALERT_SERVICE.alertMessage(context: self, title: "Campo vacío", msg: "El campo Contraseña actual no puede estar vacío")
        }else{
            if(newPassword.text == ""){
                ANIMATIONS.shakeTextField(txt: newPassword)
                ALERT_SERVICE.alertMessage(context: self, title: "Campo vacío", msg: "El campo Contraseña nueva no puede estar vacío")
            }else{
                if((newPassword.text?.characters.count)! < 6){
                    ANIMATIONS.shakeTextField(txt: newPassword)
                    ALERT_SERVICE.alertMessage(context: self, title: "Mínimo de caracteres", msg: "El campo Contraseña nueva tiene que tener al menos 6 caracteres")
                }else{
                    if(repeatPass.text == ""){
                        ANIMATIONS.shakeTextField(txt: repeatPass)
                        ALERT_SERVICE.alertMessage(context: self, title: "Campo vacío", msg: "El campo Repetir contraseña no puede estar vacío")
                    }else{
                        if((repeatPass.text?.characters.count)! < 6){
                            ANIMATIONS.shakeTextField(txt: repeatPass)
                            ALERT_SERVICE.alertMessage(context: self, title: "Mínimo de caracteres", msg: "El campo Confirmar contraseña tiene que tener al menos 6 caracteres")
                        }else{
                            if(newPassword.text == repeatPass.text ){
                                USER_SERVICE.changePassword(oldPass: oldPassword.text!, newPass: newPassword.text!, context: self)
                            }else{
                                ANIMATIONS.shakeTextField(txt: newPassword)
                                ANIMATIONS.shakeTextField(txt: repeatPass)
                                ALERT_SERVICE.alertMessage(context: self, title: "Contraseña distinta", msg: "La contraseña nueva y  confirmar contraseña no coinciden")
                            }
                        }
                    }
                }
            }
        }
        UTILITY_SERVICE.stopLoading(view: self.view)
=======
        if(newPassword.text == repeatPass.text ){
            USER_SERVICE.changePassword(oldPass: oldPassword.text!, newPass: newPassword.text!)
        }
>>>>>>> Stashed changes
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
<<<<<<< Updated upstream
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: true, context: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UTILITY_SERVICE.moveTextField(textField: textField, moveDistance: -200, up: false, context: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
=======
>>>>>>> Stashed changes

}
