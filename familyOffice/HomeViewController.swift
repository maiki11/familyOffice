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
import MIBadgeButton_Swift

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{

    let icons = ["chat", "calendar", "objetives", "gallery","safeBox", "contacts", "firstaid","property", "health"]
    let labels = ["Chat", "Calendario", "Objetivos", "Galería", "Caja Fuerte", "Contactos","Botiquín","Inmuebles", "Salud"]
    

    private var family : Family?
    

    let user = USER_SERVICE.users.first(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})
    var families : [String]! = []

   
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!


    var navigationBarOriginalOffset : CGFloat?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        //USER_SERVICE.observers()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0
        lpgr.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(lpgr)
        let moreButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_bar_more_button"), style: .plain, target: self, action:  #selector(self.handleMore(_:)))

        self.navigationItem.rightBarButtonItem = moreButton
        let barButton = UIBarButtonItem(title: "Regresar", style: .plain, target: self, action: #selector(self.handleBack))
        barButton.tintColor = #colorLiteral(red: 1, green: 0.1757333279, blue: 0.2568904757, alpha: 1)
        self.navigationItem.leftBarButtonItem = barButton
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)]
    }
    
    let settingLauncher = SettingLauncher()

    func handleMore(_ sender: Any) {
        settingLauncher.setView(view: self)
        settingLauncher.showSetting()
    }
    
    
    func handleBack()  {
        UTILITY_SERVICE.gotoView(view: "mainView", context: self)
    
    }
    
    /** ESTA FUNCION NOMAS PONE OBSERVERS */
    override func viewWillAppear(_ animated: Bool) {
        reloadFamily()
       
        if let index = FAMILY_SERVICE.families.index(where: {$0.id == USER_SERVICE.users[0].familyActive}) {
            self.navigationItem.title = FAMILY_SERVICE.families[index].name
        }
     
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            return
        }
        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in
            self.reloadFamily()
        }
        NotificationCenter.default.addObserver(forName: FAMILYADDED_NOTIFICATION, object: nil, queue: nil){family in
            self.reloadFamily()
            //FAMILY_SERVICE.verifyFamilyActive(family: family.object as! Family)
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //heightImg = familyImage.frame.size.height
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(USER_NOTIFICATION)
        NotificationCenter.default.removeObserver(NOFAMILIES_NOTIFICATION)
        NotificationCenter.default.removeObserver(FAMILYADDED_NOTIFICATION)
    }
    
    func reloadFamily() -> Void {
        if USER_SERVICE.users.count > 0, let index = FAMILY_SERVICE.families.index(where: {$0.id == USER_SERVICE.users[0].familyActive}) {
            let family = FAMILY_SERVICE.families[index]

            self.navigationItem.title = family.name
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut,animations: {
            cell.alpha = 1
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellModule", for: indexPath) as! ModuleCollectionViewCell
        
        cell.buttonicon.setImage(UIImage(named: icons[indexPath.item])!, for: .normal)
        cell.name.text = labels[indexPath.row]
        cell.buttonicon.badgeString = "8"
        cell.buttonicon.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0)
        cell.buttonicon.badgeBackgroundColor = UIColor.red
        return cell
    }
    
    

    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if (indexPath != nil ){
            switch gestureReconizer.state {
            case .began:
                gotoModule(index: (indexPath?.item)!)
                break
            case .ended:
                break
            default:
                break
            }
        }
    }
    
    func gotoModule(index: Int) -> Void {
        switch index {
        case 0:
            self.performSegue(withIdentifier: "chatSegue", sender: nil)

        case 1:
            self.performSegue(withIdentifier: "calendarSegue", sender: nil)

        case 4:
            self.performSegue(withIdentifier: "safeBoxSegue", sender: nil)

        case 8:
            self.performSegue(withIdentifier: "healthSegue", sender: nil)
        default:
            break
        }
    
    }
}
