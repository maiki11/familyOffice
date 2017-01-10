//
//  RegisterFamilyViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 04/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class RegisterFamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var activityILoad: UIActivityIndicatorView!
    
    @IBOutlet weak var galeryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imageView.isUserInteractionEnabled = true
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        storageRef = FIRStorage.storage().reference(forURL: "gs://familyoffice-6017a.appspot.com")
        //Circle image
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resournbvcvbnm,ces that can be recreated.
    }
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCameraButton(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func openPhotoLibraryButton(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = Utility.Instance().resizeImage(image: pickedImage, targetSize: CGSize(width: 200.0, height: 200.0))
        }else if let cameraImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = Utility.Instance().resizeImage(image: cameraImage, targetSize: CGSize(width: 200.0, height: 200.0))
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleAdd(_ sender: UIButton) {
        
        
        let key = ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("families").childByAutoId().key
        let imageName = NSUUID().uuidString
        
        if let uploadData = UIImagePNGRepresentation(imageView.image!){
            
            let uploadTask = storageRef.child(key).child("images").child("\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        
                        let family = ["name": self.nameTxtField.text! as String,
                                      "photoUrl": downloadURL as Any,
                                      "members": ["id": FIRAuth.auth()?.currentUser?.uid]] as [String : Any]
                        self.ref.child("families").child(key).setValue(family)
                        self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("families").setValue([ key: true])
                        Utility.Instance().gotoView(view: "TabBarControllerView", context: self.self)
                    }
                    
                }
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
