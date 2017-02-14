//
//  Utility.swift
//  
//
//  Created by Leonardo Durazo on 05/01/17.
//
//
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

private var activityIndicatior:UIActivityIndicatorView = UIActivityIndicatorView()

class Utility {
    
    private init(){
    }
    public static func Instance() -> Utility {
        return instance
    }
    static let instance : Utility = Utility()
    var state = 0
    
    func gotoView(view:String, context: UIViewController )  {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : UIViewController = storyboard.instantiateViewController(withIdentifier: view)
         context.present(viewController, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
        //if(size.width > size.height) {
            //newSize = CGSize(width: targetSize.width, height: size.width * targetSize.width / targetSize.height)
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            //newSize = CGSize(width: size.height * targetSize.width / targetSize.height, height: targetSize.height)
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func disabledView(){
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    

    func enabledView(){
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func loading(view:UIView){
        //loading
        activityIndicatior.center = view.center
        activityIndicatior.hidesWhenStopped = true
        activityIndicatior.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicatior)
        activityIndicatior.startAnimating()
    }
    
    func stopLoading(view: UIView){
        
        activityIndicatior.stopAnimating()
    }
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm"
        return formatter.string(from: Date())
    }
    
    func clearObservers(){
        REF.removeAllObservers()
        REF_USERS.removeAllObservers()
        REF_FAMILIES.removeAllObservers()
        NotificationCenter.default.removeObserver(NOFAMILIES_NOTIFICATION)
    }
    
    func exist(field: String, dictionary:NSDictionary) -> String! {
        if let value = dictionary[field] {
            return value as! String
        }else {
            return ""
        }
    }
    func existData(field: String, dictionary: NSDictionary) -> Data? {
        if let value = dictionary[field] {
            return (value as! Data)
        }else {
            return UIImagePNGRepresentation(#imageLiteral(resourceName: "Profile2") )
        }
    }
    func existArray(field: String, dictionary:NSDictionary) -> [Any] {
        if let value = dictionary[field] {
            return value as! Array<Any>
        }else {
            return []
        }
    }
    func existNSDictionary(field: String, dictionary:NSDictionary) -> NSDictionary {
        if let value = dictionary[field] {
            return value as! NSDictionary
        }else {
            return [:]
        }
    }

}
