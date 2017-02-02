//
//  PasswordChangeViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {
    let userService = UserService.Instance()
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Atras", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Cambiar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(PasswordChangeViewController.changePassword(sender:)))
        
        self.navigationItem.backBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = doneButton
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
             Utility.Instance().stopLoading(view: self.view)
        }
        NotificationCenter.default.addObserver(forName: ERROR_NOTIFICATION, object: nil, queue: nil){_ in
             Utility.Instance().stopLoading(view: self.view)
           
        }
        
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
    
    func changePassword(sender: UIBarButtonItem) -> Void {
        Utility.Instance().loading(view: self.view)
        if(newPassword.text == repeatPass.text){
            userService.changePassword(oldPass: oldPassword.text!, newPass: newPassword.text!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
