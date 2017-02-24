//
//  HomeViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 05/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController {
    
 
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var familyImage: UIImageView!
    @IBOutlet weak var familyName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        USER_SERVICE.observers()
        UTILITY_SERVICE.loading(view: self.view)
    
        self.navBar.isHidden = true
        self.familyImage.layer.cornerRadius = self.familyImage.frame.size.width/2
        self.familyImage.clipsToBounds = true
        
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            UTILITY_SERVICE.gotoView(view: "RegisterFamilyView", context: self)
            return
        }
        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in
            Utility.Instance().stopLoading(view: self.view)
            self.reloadFamily()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadFamily()
    }
    
    func reloadFamily() -> Void {
        if let family = FAMILY_SERVICE.families.filter({$0.id == (USER_SERVICE.user?.familyActive)! as String}).first{
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = STORAGE_SERVICE.search(url: (family.photoURL?.absoluteString)!) {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        UTILITY_SERVICE.stopLoading(view: self.view)
                        self.familyImage.image = UIImage(data: data)
                    }
                }
            }
            self.familyName.text = family.name ?? "No seleccionada"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
