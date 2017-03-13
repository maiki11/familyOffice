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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let myImages=["chat_home.png","calendar_home.png","contacts_home.png","target_home.png","chat_home.png","calendar_home.png","contacts_home.png","target_home.png","chat_home.png","calendar_home.png","contacts_home.png","target_home.png","chat_home.png","calendar_home.png","contacts_home.png","target_home.png"]
    let newHeight: CGFloat = 60
    let heightHeader: CGFloat = 200
    let top: CGFloat = 20
    var headPosY: CGFloat = 0
    var famPosY: CGFloat = 0
    private var flag = true
    private var family : Family?
    let user = USER_SERVICE.users.first(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var familyImage: UIImageView!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var heightImg: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var startPosX: CGFloat = 0
    private var headWidth: CGFloat = 0
    private var collectionHeight: CGFloat = 0
    
    private var headerExpanded = true
    private var headerAnimating = false
    
    var navigationBarOriginalOffset : CGFloat?
    
    
    @IBOutlet weak var famImageCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var famImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var famNameLeadingConstraint: NSLayoutConstraint!
    
    var famExpandedHeight: CGFloat = 0
    let famCollapsedHeight: CGFloat = 40
    
    var collectionOriginalHeight: CGFloat = 0
    var famImageOriginalSize: CGFloat = 0
    var famImageOriginalX: CGFloat = 0
    var famImageOriginalY: CGFloat = 0
    var isExpanded = true
    
    var famImagePositionXConstraint: NSLayoutConstraint?
    var famNamePositionXConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //USER_SERVICE.observers()
        
        self.familyImage.layer.cornerRadius = self.familyImage.frame.size.width/2
        self.headPosY = self.headerView.frame.origin.y
        self.headWidth = self.headerView.frame.width
        self.famPosY = familyName.frame.origin.y
        self.collectionHeight = collectionView.frame.height
        lastContentOffset = familyImage.frame.size.height/2
        heightImg = familyImage.frame.size.height
        self.familyImage.layer.cornerRadius = lastContentOffset
        self.familyImage.clipsToBounds = true
        
        collectionView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        famExpandedHeight = famImageWidthConstraint.constant
        collectionOriginalHeight = collectionView.frame.height
        famImageOriginalSize = familyImage.frame.size.width
        famImageOriginalX = familyImage.frame.origin.x
        famImageOriginalY = familyImage.frame.origin.y
        famImagePositionXConstraint = familyImage.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        famImagePositionXConstraint?.isActive = true
        famImagePositionXConstraint?.priority = UILayoutPriorityDefaultLow
        famNamePositionXConstraint = familyName.leadingAnchor.constraint(equalTo: familyName.trailingAnchor)
        famNamePositionXConstraint?.isActive = true
        famNamePositionXConstraint?.priority = UILayoutPriorityDefaultLow
        familyImage.image = #imageLiteral(resourceName: "familyImage")
    }
    
    /** ESTA FUNCION NOMAS PONE OBSERVERS */
    override func viewWillAppear(_ animated: Bool) {
        reloadFamily()
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            self.familyImage.image = #imageLiteral(resourceName: "Family")
            self.familyName.text = "Sin familia seleccionada"
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
    
    /** Quita los observers */
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(USER_NOTIFICATION)
        NotificationCenter.default.removeObserver(NOFAMILIES_NOTIFICATION)
        NotificationCenter.default.removeObserver(FAMILYADDED_NOTIFICATION)
    }
    
    func reloadFamily() -> Void {
        if let family = FAMILY_SERVICE.families.first(where: {$0.id == (USER_SERVICE.users[0].familyActive)! as String}){
            if let url = family.photoURL {
                self.familyImage.loadImage(urlString: url)
            }
            self.familyName.text = family.name
        }else{
            self.familyImage.image = #imageLiteral(resourceName: "Family")
            self.familyName.text = "Sin familia seleccionada"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = collectionView.contentOffset.y
        let maxScroll = famExpandedHeight - famCollapsedHeight
        if offsetY > maxScroll && isExpanded {
            isExpanded = false
            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.famImageCenterXConstraint.priority = UILayoutPriorityDefaultLow
                self.famImagePositionXConstraint?.priority = UILayoutPriorityDefaultHigh
                self.famImageWidthConstraint.constant = self.famCollapsedHeight
                self.famNameLeadingConstraint.priority = UILayoutPriorityDefaultLow
                self.famNamePositionXConstraint?.priority = UILayoutPriorityDefaultHigh
                self.view.layoutIfNeeded()
            })
            let anim = CABasicAnimation(keyPath: "cornerRadius")
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            anim.fromValue = familyImage.layer.cornerRadius
            anim.toValue = self.famCollapsedHeight/2
            anim.duration = 0.8
            self.familyImage.layer.cornerRadius = self.famCollapsedHeight/2
            self.familyImage.layer.add(anim, forKey: "cornerRadius")
        } else if offsetY < maxScroll && !isExpanded {
            isExpanded = true
            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.famImageCenterXConstraint.priority = UILayoutPriorityDefaultHigh
                self.famImagePositionXConstraint?.priority = UILayoutPriorityDefaultLow
                self.famImageWidthConstraint.constant = self.famExpandedHeight
                self.famNameLeadingConstraint.priority = UILayoutPriorityDefaultHigh
                self.famNamePositionXConstraint?.priority = UILayoutPriorityDefaultLow
                self.view.layoutIfNeeded()
            })
            let anim = CABasicAnimation(keyPath: "cornerRadius")
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            anim.fromValue = familyImage.layer.cornerRadius
            anim.toValue = self.famExpandedHeight/2
			anim.duration = 0.8
            self.familyImage.layer.cornerRadius = self.famExpandedHeight/2
            self.familyImage.layer.add(anim, forKey: "cornerRadius")
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
        return myImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellModule", for: indexPath) as! ModuleCollectionViewCell
        cell.image.image = UIImage(named: myImages[indexPath.item])!
        return cell
        
    }
}
