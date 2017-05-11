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

class HomeViewController: UIViewController,  UIGestureRecognizerDelegate{

    let icons = ["chat", "calendar", "objetives", "gallery","safeBox", "contacts", "firstaid","property", "health","seguro-purple"]
    let labels = ["Chat", "Calendario", "Objetivos", "Galería", "Caja Fuerte", "Contactos","Botiquín","Inmuebles", "Salud", "Seguros"]
    

    private var family : Family?

    let user = Constants.Services.USER_SERVICE.users.first(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})
    var families : [String]! = []

   
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerPopupConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var valueModal: UIView!
    @IBOutlet weak var backgroundButton: UIButton!


    var navigationBarOriginalOffset : CGFloat?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigurationNavBar()
    }
    
    let settingLauncher = SettingLauncher()

    @IBAction func handleCloseModal(_ sender: UIButton) {
        centerPopupConstraint.constant = -370
        UIView.animate(withDuration: 0.1, animations: {
          self.view.layoutIfNeeded()
          self.backgroundButton.alpha = 0
        })
        
    }
    
    func handleBack()  {
        Constants.Services.UTILITY_SERVICE.gotoView(view: "mainView", context: self)
    }
    
    /** ESTA FUNCION NOMAS PONE OBSERVERS */
    override func viewWillAppear(_ animated: Bool) {
        reloadFamily()
        createObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //heightImg = familyImage.frame.size.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(Constants.NotificationCenter.USER_NOTIFICATION)
        NotificationCenter.default.removeObserver(Constants.NotificationCenter.NOFAMILIES_NOTIFICATION)
        NotificationCenter.default.removeObserver(Constants.NotificationCenter.FAMILYADDED_NOTIFICATION)
    }
    

}
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut,animations: {
            cell.alpha = 1
        })
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellModule", for: indexPath) as! ModuleCollectionViewCell
        cell.buttonicon.setBackgroundImage(UIImage(named: icons[indexPath.item])!, for: .normal)
        cell.name.text = labels[indexPath.row]
        cell.buttonicon.badgeString = "8"
        cell.buttonicon.badgeEdgeInsets = UIEdgeInsetsMake(10, 10, 0, 0)
        cell.buttonicon.badgeBackgroundColor = UIColor.red
        
        return cell
    }
    
    func reloadFamily() -> Void {
        if Constants.Services.USER_SERVICE.users.count > 0, let index = Constants.Services.FAMILY_SERVICE.families.index(where: {$0.id == Constants.Services.USER_SERVICE.users[0].familyActive}) {
            let family = Constants.Services.FAMILY_SERVICE.families[index]
            
            self.navigationItem.title = family.name
        }
    }
    
}
extension HomeViewController {
   
    func createObservers() -> Void {
        if let index = Constants.Services.FAMILY_SERVICE.families.index(where: {$0.id == Constants.Services.USER_SERVICE.users[0].familyActive}) {
            self.navigationItem.title = Constants.Services.FAMILY_SERVICE.families[index].name
        }
        
        NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            return
        }
        NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.USER_NOTIFICATION, object: nil, queue: nil){_ in
            self.reloadFamily()
        }
        NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.FAMILYADDED_NOTIFICATION, object: nil, queue: nil){family in
            self.reloadFamily()
            //FAMILY_SERVICE.verifyFamilyActive(family: family.object as! Family)
        }
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
    func handleMore(_ sender: Any) {
        settingLauncher.setView(view: self)
        settingLauncher.showSetting()
    }
    func handleShowModal(_ sender: Any) -> Void {
        centerPopupConstraint.constant = 0
        self.backgroundButton.backgroundColor = UIColor.black
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundButton.alpha = 0.65
        })
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
    func setupConfigurationNavBar() -> Void {
        //USER_SERVICE.observers()
        valueModal.layer.cornerRadius = 10
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0
        lpgr.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(lpgr)
        let moreButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_bar_more_button"), style: .plain, target: self, action:  #selector(self.handleMore(_:)))
        let valueButton = UIBarButtonItem(image: #imageLiteral(resourceName: "value"), style: .plain, target: self, action:  #selector(self.handleShowModal(_:)))
        
        self.navigationItem.rightBarButtonItems = [ moreButton,valueButton]
        let barButton = UIBarButtonItem(title: "Regresar", style: .plain, target: self, action: #selector(self.handleBack))
        
        barButton.tintColor = #colorLiteral(red: 1, green: 0.1757333279, blue: 0.2568904757, alpha: 1)
        self.navigationItem.leftBarButtonItem = barButton
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)]
    }
    
}
