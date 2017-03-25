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
import Toast_Swift
import Contacts
import ContactsUI

class RegisterFamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    let center = NotificationCenter.default
    var contacts : [CNContact] = []
    var selected : [User] = []
    var users : [User] = []
    var itemCount = 0
    var localeChangeObserver : NSObjectProtocol!
    let IndexPathOfFirstRow = NSIndexPath(row: 0, section: 0)
    var firstCell : SelectedTableViewCell!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var nameTxtField: textFieldStyleController!
    
    var imageView = UIImageView()
    var blurImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(title: "Crear", style: .plain, target: self, action: #selector(self.cropAndSave(_:)))
        navigationItem.rightBarButtonItems = [saveButton]
        navigationItem.title = "Crear Familia"
        scrollView.delegate = self
        blurImageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        blurImageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(blurImageView)
        scrollView.addSubview(imageView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.loadImage(_:)))
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func loadImage(_ recognizer: UITapGestureRecognizer){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func handleAdd(_ sender: Any) {
        save()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        scrollView.zoomScale = 1
        self.imageView.image = image
        
        blurImageView.image = imageView.image
        imageView.contentMode = UIViewContentMode.center
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: scrollView.frame.size.height)
        scrollView.contentSize = image.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        centerScrollViewContents()
        
        //blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurImageView.addSubview(blurEffectView)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        imageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    override func viewWillDisappear(_ animated: Bool) {
        UTILITY_SERVICE.enabledView()
        selected = []
        center.removeObserver(self.localeChangeObserver)
        REF_USERS.removeAllObservers()
        super.viewDidDisappear(animated)
    }
    
    func cropAndSave(_ sender: Any) {
        save()
    }
    func save() -> Void {
        let key = REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").childByAutoId().key
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)
        let offset = scrollView.contentOffset
        
        UIGraphicsGetCurrentContext()?.translateBy(x: -offset.x, y: -offset.y)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Add validations
        if(imageView.image != nil && nameTxtField.text != nil){
            self.view.makeToastActivity(.center)
            selected.append(USER_SERVICE.users[0])
            FAMILY_SERVICE.createFamily(key: key, image: image!, name: nameTxtField.text!, users: selected, view: self.self)
            //UTILITY_SERVICE.loading(view: self.view)
            UTILITY_SERVICE.disabledView()
        }else{
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ANIMATIONS.shakeTextField(txt: nameTxtField)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logout(_ sender: Any){
        AUTH_SERVICE.logOut()
        Utility.Instance().gotoView(view: "StartView", context: self)
    }
}
