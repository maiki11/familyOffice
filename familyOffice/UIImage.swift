//
//  UIImage.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 06/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImage(urlString: String) -> Void {
        
        let url = URL(string: urlString)
    
        //check if image exist in cache
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = nil
            self.image = cacheImage as? UIImage
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    self.image = nil
                    self.image = downloadImage
                }
            }
        }).resume()

    }
}
