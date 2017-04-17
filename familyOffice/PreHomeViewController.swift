//
//  SelectCategoryViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 15/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController {
    var families : [Family]! = []
    var imageSelect : UIImage!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var familiesCollection: UICollectionView!
    @IBOutlet weak var familiasView: UIView!
    @IBOutlet weak var categoriasView: UIView!
    @IBOutlet weak var empresarialView: UIView!
    @IBOutlet weak var socialView: UIView!
    var localeChangeObserver :[NSObjectProtocol] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(self.logout))
        logOutButton.tintColor = #colorLiteral(red: 1, green: 0.1757333279, blue: 0.2568904757, alpha: 1)
        navigationItem.rightBarButtonItems = [logOutButton]
        
        self.headerView.layer.borderWidth = 1
        self.headerView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.familiasView.layer.borderWidth = 1
        self.familiasView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.familiasView.layer.cornerRadius = 5
        self.categoriasView.layer.borderWidth = 1
        self.categoriasView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.categoriasView.layer.cornerRadius = 5
        self.socialView.layer.borderWidth = 1
        self.socialView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.socialView.layer.cornerRadius = 5
        self.empresarialView.layer.borderWidth = 1
        self.empresarialView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
        self.empresarialView.layer.cornerRadius = 5
    }
    @IBAction func handlePressSocial(_ sender: UIButton) {
        if Constants.Services.FAMILY_SERVICE.families.count > 0 && Constants.Services.FAMILY_SERVICE.families.contains(where: {$0.id == Constants.Services.USER_SERVICE.users[0].familyActive}){
            Constants.Services.UTILITY_SERVICE.gotoView(view: "TabBarControllerView", context: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.familiesCollection.reloadData()
        if Constants.Services.USER_SERVICE.users.count > 0 {
            loadImage()
        }
        
        families = Constants.Services.FAMILY_SERVICE.families
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.USER_NOTIFICATION, object: nil, queue: nil){_ in
            self.loadImage()
        })
        localeChangeObserver.append(NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.FAMILYADDED_NOTIFICATION, object: nil, queue: nil){family in
            if let family : Family = family.object as? Family {
                self.addFamily(family: family)

            }
        })

    }
    override func viewWillDisappear(_ animated: Bool) {
        for obs in localeChangeObserver{
            NotificationCenter.default.removeObserver(obs)
        }
        self.localeChangeObserver.removeAll()
    }
    func loadImage() -> Void {
        if !Constants.Services.USER_SERVICE.users[0].photoURL.isEmpty {
            image.loadImage(urlString: Constants.Services.USER_SERVICE.users[0].photoURL)
        }else{
            image.image = #imageLiteral(resourceName: "profile_default")
        }
        self.name.text = Constants.Services.USER_SERVICE.users[0].name
        self.image.layer.cornerRadius = self.image.frame.size.width/2
        self.image.clipsToBounds = true
        self.image.layer.borderWidth = 4.0
        self.image.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        self.image.layer.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
    }
    
    @IBAction func handleBussiness(_ sender: UIButton) {
        if Constants.Services.FAMILY_SERVICE.families.count > 0 && Constants.Services.FAMILY_SERVICE.families.contains(where: {$0.id == Constants.Services.USER_SERVICE.users[0].familyActive}){
            Constants.Services.UTILITY_SERVICE.gotoView(view: "HomeBussiness", context: self)
        }
        
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func logout(){
        Constants.Services.AUTH_SERVICE.logOut()
        //Utility.Instance().gotoView(view: "StartView", context: self)
    }
    
}
