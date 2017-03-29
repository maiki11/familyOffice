//
//  ProfileUserViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {
    var placeholders = ["Nombre", "Teléfono", "Dirección", "Fecha de Cumpleaños", "RFC", "CURP", "NSS", "Tipo de sangre"]
    var aboutkeys = ["name", "phone",  "address","birthday", "rfc", "curp", "nss", "bloodType"]
    var families : [Family] = []
    var userDic : NSDictionary! = [:]
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    var index: Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var familiesCollection: UICollectionView!
    @IBOutlet weak var infoTable: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        REF_SERVICE.valueSingleton(ref: "users/\(USER_SERVICE.users[index].id!)")
        if !(USER_SERVICE.users[index].photoURL.isEmpty) {
            profileImage.loadImage(urlString: USER_SERVICE.users[index].photoURL)
            
        }else{
            profileImage.image = #imageLiteral(resourceName: "profile_default")
        }
        name.text = USER_SERVICE.users[index].name
        userDic = USER_SERVICE.users[index].toDictionary()
        
        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in
            self.userDic = USER_SERVICE.users[self.index].toDictionary()
            self.setFamiliesInComun()
            
            self.familiesCollection.reloadData()
            self.infoTable.reloadData()
        }
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        self.infoTable.layer.borderWidth = 1
        self.infoTable.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.infoTable.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userDic = [:]
        families = []
        self.familiesCollection.reloadData()
        self.infoTable.reloadData()
    }
    @IBAction func handleChangeSegmented(_ sender: UISegmentedControl) {
        infoTable.isHidden = true
        familiesCollection.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            infoTable.isHidden = false
        }else if sender.selectedSegmentIndex == 1 {
            familiesCollection.isHidden = false
        }
    }
    
}



