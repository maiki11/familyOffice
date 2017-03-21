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
    private var family : Family?
    let user = USER_SERVICE.users.first(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var familyName: String!
    var famImage: UIImage!
    //private let heightHeader //height from header
    
    //private var familyName: UILabel!
    //private var familyImage: UIImageView! = UIImageView(image: #imageLiteral(resourceName: "Family"))
    //private var activityIndicator: UIActivityIndicatorView!
    
    var navigationBarOriginalOffset : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true

        UTILITY_SERVICE.loading(view: self.view)
        //self.familyImage.frame = CGRect(x: 10, y: 10, width: 140, height: 140)
        //self.familyImage.layer.cornerRadius = self.familyImage.frame.size.width/2
        //self.famPosY = familyName.frame.origin.y
        //self.collectionHeight = collectionView.frame.height
        //lastContentOffset = familyImage.frame.size.height/2
        //self.familyImage.layer.cornerRadius = lastContentOffset
        //self.familyImage.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadFamily()
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            //self.activityIndicator.stopAnimating()
            self.famImage = #imageLiteral(resourceName: "Family")
            self.familyName = "No tiene familias, por favor \n crea una familia"
            return
        }
        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in
            Utility.Instance().stopLoading(view: self.view)
            self.reloadFamily()
        }
        NotificationCenter.default.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){_ in
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
        NotificationCenter.default.removeObserver(SUCCESS_NOTIFICATION)
        NotificationCenter.default.removeObserver(NOFAMILIES_NOTIFICATION)
        NotificationCenter.default.removeObserver(FAMILYADDED_NOTIFICATION)
    }
    
    func reloadFamily() -> Void {
        if let family = FAMILY_SERVICE.families.filter({$0.id == (USER_SERVICE.users.first(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})?.familyActive)! as String}).first{
<<<<<<< HEAD
            if let data = STORAGE_SERVICE.search(url: (family.photoURL?.absoluteString)!) {
                //self.activityIndicator.stopAnimating()
                UTILITY_SERVICE.stopLoading(view: self.view)
                //self.familyImage.image = UIImage(data: data)
                self.famImage = UIImage(data: data)
=======
            if let url = family.photoURL {
                self.activityIndicator.stopAnimating()
                UTILITY_SERVICE.stopLoading(view: self.view)
                self.familyImage.loadImage(urlString: url)
>>>>>>> master
            }
            
            self.familyName = family.name ?? "No seleccionada"
            self.collectionView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.bounces = false
        /*let header = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: IndexPath(item: 0, section: 0))
        if(scrollView.contentOffset.y >= 100 && scrollView.contentOffset.y <= 240){
            header.frame.size.height  = 200 - (scrollView.contentOffset.y - 100)
            //let percent = 40/self.headerView.frame.size.height
            //let posX: CGFloat = (self.headWidth / -2) + 40
            //let posY: CGFloat = ( self.headerView.frame.size.height ) * -1
            //self.familyImage.transform = CGAffineTransform(scaleX: percent, y: percent).concatenating(CGAffineTransform(translationX: posX, y: posY))
            //self.familyName.transform = CGAffineTransform(translationX: posX+(self.familyName.frame.width/2)-40, y: (self.headPosY-self.famPosY) - 5 )
            //self.headerView.frame.size.height = self.heightHeader - (scrollView.contentOffset.y - 100)
            
        }else{
            if(scrollView.contentOffset.y < 100 && self.headerView.frame.height < self.heightHeader){
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //self.headerView.frame.size.height = self.heightHeader
                    //self.collectionView.frame.origin.y = self.heightHeader + 10
                }, completion: nil)
            }
        }*/
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = false
        if(collectionView.contentOffset.y >= 100 && self.headerView.frame.height == heightHeader){
            let percent = 40/self.heightHeader
            let posX: CGFloat = (self.headWidth / -2) + 40
            let posY: CGFloat = ( newHeight ) * -1
            if(self.headerView.frame.size.height > self.newHeight){
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.familyImage.transform = CGAffineTransform(scaleX: percent, y: percent).concatenating(CGAffineTransform(translationX: posX, y: posY))
                        self.familyName.transform = CGAffineTransform(translationX: posX+(self.familyName.frame.width/2)-40, y: (self.headPosY-self.famPosY) - 5 )
                        self.headerView.frame.size.height = self.newHeight
                        self.collectionView.frame.origin.y = -posY
                        self.collectionView.frame.size.height = self.collectionView.frame.size.height + self.heightHeader - 15
                    }, completion: nil)
                }
                
            }
        }else if (0 >= collectionView.contentOffset.y){
            let percent = 1
            let scale = CGAffineTransform(scaleX: CGFloat(percent), y: CGFloat(percent))
            //DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.familyImage.transform = scale
                self.headerView.frame.size.height = self.heightHeader
                self.collectionView.frame.origin.y = self.heightHeader + 20
                self.familyName.transform = CGAffineTransform(translationX: 0, y: 0 )
                //self.collectionView.frame.size.height = self.collectionHeight
            }, completion: nil)
        }
    }*/
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderHomeView", for: indexPath) as! HeaderHomeView
        header.familyName.text = self.familyName
        header.familyImage.image = famImage
        return header
    }
    
}
