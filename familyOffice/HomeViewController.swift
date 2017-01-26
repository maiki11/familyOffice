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
    var user: String = ""
    
    @IBOutlet weak var familyImage: UIImageView!
    @IBOutlet weak var familyName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.familyImage.layer.cornerRadius = self.familyImage.frame.size.width/2
        self.familyImage.clipsToBounds = true
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            
            self.checkFamily()
        }
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            self.user = User.Instance().getData().name
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let family = User.Instance().getData().family
        self.familyImage.image = family?.photo
        self.familyName.text = family?.name ?? "No seleccionada"
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
