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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var familiesCollection: UICollectionView!
    var localeChangeObserver :[NSObjectProtocol] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func handlePressSocial(_ sender: UIButton) {
        if FAMILY_SERVICE.families.count > 0 && FAMILY_SERVICE.families.contains(where: {$0.id == USER_SERVICE.users[0].familyActive}){
            self.performSegue(withIdentifier: "socialSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.familiesCollection.reloadData()
        if USER_SERVICE.users.count > 0 {
            loadImage()
        }
        
        families = FAMILY_SERVICE.families
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in
            self.loadImage()
        })
        localeChangeObserver.append(NotificationCenter.default.addObserver(forName: FAMILYADDED_NOTIFICATION, object: nil, queue: nil){family in
            if let family : Family = family.object as? Family {
                self.addFamily(family: family)
                self.familiesCollection.reloadData()
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
        if !USER_SERVICE.users[0].photoURL.isEmpty {
            image.loadImage(urlString: USER_SERVICE.users[0].photoURL)
        }else{
            image.image = #imageLiteral(resourceName: "profile_default")
        }
        self.name.text = USER_SERVICE.users[0].name
        self.image.layer.cornerRadius = self.image.frame.size.width/2
        self.image.clipsToBounds = true
    }
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }


}
