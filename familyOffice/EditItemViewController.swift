//
//  EditItemViewController.swift
//  familyOffice
//
//  Created by Ernesto Salazar on 7/12/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
import ReSwift
import ReSwiftRouter

class EditItemViewController: UIViewController {
    var item:ToDoList.ToDoItem!
    var imagePicker: UIImagePickerController!
    var initialPhoto: String!
    var tookPhoto:Bool = false
    
    @IBOutlet var textFieldTitle: UITextField!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var addPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(save(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        textFieldTitle.text = item.title
        photo.loadImage(urlString: item.photoUrl!)
        initialPhoto = item.photoUrl!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizeImage(image: UIImage, scale: CGFloat) -> UIImage {
        
        let newWidth = image.size.width * (scale/100)
        let newHeight = image.size.height * (scale/100)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func save(sender: UIBarButtonItem){
        
        let title: String! = textFieldTitle.text
        if title == nil || title.isEmpty{
            service.ANIMATIONS.shakeTextField(txt: textFieldTitle)
            self.view.makeToast("Agrega un título", duration: 1.0, position: CGPoint(x: 200, y: 150))
            return
        }
        
        self.item.title = title
        
        let photoName = NSUUID().uuidString
        //        let user = service.USER_SERVICE.users[0]
        var photoUrl:String = initialPhoto
        
        if tookPhoto {
            photo?.image = resizeImage(image: (photo?.image!)!, scale: 20)
            let uploadData = UIImagePNGRepresentation((photo?.image)!)
            Constants.FirStorage.STORAGEREF.child("users/\(service.USER_SERVICE.users[0].id!)").child("images/\(photoName).png").put(uploadData!, metadata: nil){ metadata, error in
                if error != nil{
                    print(error.debugDescription)
                }else{
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString{
                        StorageService.Instance().save(url: downloadUrl, data: uploadData)
                        photoUrl = downloadUrl
                        self.item.photoUrl = photoUrl
                        store.dispatch(UpdateToDoListItemAction(item:self.item))
                    }
                }
            }
        }else{
            store.dispatch(UpdateToDoListItemAction(item:self.item))
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        photo?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        tookPhoto = true
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

extension EditItemViewController :  UIImagePickerControllerDelegate  {
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension EditItemViewController: StoreSubscriber{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        store.subscribe(self){
            state in state.ToDoListState
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.state.ToDoListState.status = .none
        store.unsubscribe(self)
    }
    
    func toggleToDoState(message: String) -> Void {
        // No sé por qué ocupo mostrar un Toast primero, si no lo hago hace doble popViewController
        // y no hay mucho tiempo para andar viendo por qué. Por eso lo escondo en la posición 3000:110
        self.view.makeToast(message, duration: 0.01, position: CGPoint(x: 3000.0, y: 110.0), title: "Mensaje:", image: nil, style: nil) { bool in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func newState(state: ToDoListState){
        switch state.status {
        case .failed:
            self.view.makeToast("Ocurrio un error, intente de nuevo")
            break
        case .loading:
            self.view.makeToastActivity(.center)
            break
        case .finished:
            self.view.hideToastActivity()
            toggleToDoState(message: "Tarea añadida")
            break
        default: break
        }
    }
}

