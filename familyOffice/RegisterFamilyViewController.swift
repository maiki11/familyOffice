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

private let utility = Utility.Instance()

class RegisterFamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var activityILoad: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    var imageView2 = UIImageView()
    var heightScrollView = 0.0
    
    //let imagePicker = UIImagePickerController()
    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.heightScrollView = Double(scrollView.frame.size.height)
        imageView2.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        //imageView2.image = UIImage(named: "image_blank")
        //imageView2.contentMode = .scaleAspectFit
        imageView2.isUserInteractionEnabled = true
        
        scrollView.addSubview(imageView2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.loadImage(_:)))
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView2.addGestureRecognizer(tapGestureRecognizer)
        
        
        // Do any additional setup after loading the view.
        //imagePicker.delegate = self
        //imageView.isUserInteractionEnabled = true
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        storageRef = FIRStorage.storage().reference(forURL: "gs://familyoffice-6017a.appspot.com")
        //Circle image
        /*imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true*/
    }
    
    func loadImage(_ recognizer: UITapGestureRecognizer){
        //scrollView.frame.size.width = self.view.frame.size.width
        //scrollView.frame.size.height = CGFloat(self.heightScrollView)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resournbvcvbnm,ces that can be recreated.
    }
    
    /*
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
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
        
    }*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView2.image = image
        imageView2.contentMode = UIViewContentMode.center
        imageView2.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        scrollView.contentSize = image.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width/scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height/scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
        picker.dismiss(animated: true, completion: nil)
        
        centerScrollViewContents()
        
        /*if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = Utility.Instance().resizeImage(image: pickedImage, targetSize: CGSize(width: 600.0, height: 600.0))
        }else if let cameraImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = Utility.Instance().resizeImage(image: cameraImage, targetSize: CGSize(width: 600.0, height: 600.0))
        }
        dismiss(animated: true, completion: nil)*/
    }
    
    func centerScrollViewContents(){
        //let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView2.frame
        
        contentsFrame.origin.x = 0
        contentsFrame.origin.y = 0
        
        /*if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = 0//(boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = 0//boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }*/
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView2
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleAdd(_ sender: UIButton) {
        let key = ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("families").childByAutoId().key
        //Add validations
        if(imageView2.image != nil && nameTxtField.text != nil){
             FamilyService.instance.createFamily(key: key, image: imageView2.image!, name: nameTxtField.text!, view: self.self)
            utility.loading(view: self.view)
            utility.disabledView()
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
            
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(UIAlertAction) in
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
            
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        utility.enabledView()
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
