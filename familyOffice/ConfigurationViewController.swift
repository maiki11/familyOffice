//
//  ConfigurationViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 27/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfigurationViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    var user: User!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var containerView: ConfigurationView!
    @IBOutlet weak var iconView: UIView!
    let picker = UIImagePickerController()
    var chosenImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        self.profileImage.clipsToBounds = true
        self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2
        self.iconView.clipsToBounds = true
        iconView.layer.borderWidth = 1
        iconView.layer.borderColor = UIColor(red: 238.0/255, green: 69.0/255, blue: 74.0/255, alpha: 1).cgColor
        picker.delegate = self
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)]
        // Do any additional setup after loading the view.
        STYLES.borderbottom(textField: headerView, color: UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), width: 1.0)
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.containerView.layer.cornerRadius = 5
        self.profileImage.layer.borderWidth = 4.0
        self.profileImage.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        self.profileImage.layer.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        user = USER_SERVICE.users[0]
        if !user.photoURL.isEmpty {
            profileImage.loadImage(urlString: user.photoURL)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //profileImage.contentMode = .scaleAspectFit //3
        //profileImage.image = chosenImage.image //4
        self.performSegue(withIdentifier: "updateImageSegue", sender: nil)
        
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            self.picker.sourceType = .camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            } else {
                self.noCamera()
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="updateImageSegue" {
            let viewController = segue.destination as! ImageViewController
            viewController.imageView.image = chosenImage
        }
     }
     
    
}
