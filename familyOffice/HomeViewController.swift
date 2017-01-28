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
    
    var ref: FIRDatabaseReference!
<<<<<<< HEAD

    var family = User.Instance().getData().family

=======
    var userService =  UserService.Instance()
    var family = UserService.Instance().user?.family
    var utilityService = Utility.Instance()
>>>>>>> master
    @IBOutlet weak var familyImage: UIImageView!
    @IBOutlet weak var familyName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.Instance().loading(view: self.view)
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
        family = userService.user?.family
        
        if(family != nil){
            self.familyImage.image = UIImage(data: (family?.photoData)!)
            self.familyName.text = family?.name ?? "No seleccionada"
            Utility.Instance().stopLoading(view: self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkFamily(){
        print(FamilyService.instance.families.count)
        
        if(FamilyService.instance.families.count == 0){
            Utility.Instance().gotoView(view: "RegisterFamilyView", context: self)
        }
    }
    
}
