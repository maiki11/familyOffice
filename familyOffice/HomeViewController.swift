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
    
    private var family : Family?

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var familyImage: UIImageView!
    @IBOutlet weak var familyName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        UTILITY_SERVICE.loading(view: self.view)
=======
        self.navBar.isHidden = true
        Utility.Instance().loading(view: self.view)
>>>>>>> maiki11
        reloadFamily()
        self.familyImage.layer.cornerRadius = self.familyImage.frame.size.width/2
        self.familyImage.clipsToBounds = true
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            self.checkFamily()
        }

        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in 
            self.reloadFamily()
            Utility.Instance().stopLoading(view: self.view)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
   
    func reloadFamily() -> Void {
        family = USER_SERVICE.user?.family
        if(self.family != nil){
            if let data = STORAGE_SERVICE.search(url: (self.family?.photoURL?.absoluteString)!) {
                self.familyImage.image = UIImage(data: data)
            }
            self.familyName.text = family?.name ?? "No seleccionada"
            Utility.Instance().stopLoading(view: self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkFamily(){
        print(FAMILY_SERVICE.families.count)
        
        if(FAMILY_SERVICE.families.count == 0){
            Utility.Instance().gotoView(view: "RegisterFamilyView", context: self)
        }
    }
    
}
