//
//  ProfileUserViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    var index: Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var familiesContainer: UIView!
    
    @IBOutlet weak var infoContainer: UIView!
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
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    @IBAction func handleChangeSegmented(_ sender: UISegmentedControl) {
        infoContainer.isHidden = true
        familiesContainer.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            infoContainer.isHidden = false
        }else if sender.selectedSegmentIndex == 1 {
            familiesContainer.isHidden = false
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="familiesEmbedSegue" {
            let viewController = segue.destination as! familiesContainerCollectionViewController
            viewController.index = self.index!
        }else if segue.identifier == "infoContainerSegue" {
            let viewController = segue.destination as! InfoContaineeTableViewController
            viewController.index = self.index!
        }
     }
    
    
}
