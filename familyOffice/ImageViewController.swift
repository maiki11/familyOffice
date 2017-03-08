//
//  ImageViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
class ImageViewController: UIViewController {
    var image: UIImage! = nil
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(save(sender:)))
        self.navigationItem.rightBarButtonItem = doneButton
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = image
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func save(sender: UIBarButtonItem) -> Void {
        self.view.makeToastActivity(.center)
         UTILITY_SERVICE.disabledView()
        //Add validations
        if(imageView.image != nil){
            let imageName = NSUUID().uuidString
            if let uploadData = UIImagePNGRepresentation(image){
                _ = STORAGEREF.child("users/\(USER_SERVICE.users[0].id!)").child("images/\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print(error.debugDescription)
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        if let downloadURL = metadata?.downloadURL()?.absoluteURL {
                            StorageService.Instance().save(url: downloadURL.absoluteString, data: uploadData)
                            USER_SERVICE.users[0].photoURL = downloadURL.absoluteString
                            REQUEST_SERVICE.update(value: ["photoUrl": downloadURL.absoluteString ], ref: "users/\(USER_SERVICE.users[0].id!)")
                            self.image = nil
                            UTILITY_SERVICE.enabledView()
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                }
            }
            
            //UTILITY_SERVICE.loading(view: self.view)
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Agregue una imagen y un nombre", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
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
