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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    var navigationBarOriginalOffset : CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        USER_SERVICE.observers()
        UTILITY_SERVICE.loading(view: self.view)
        
        self.familyImage.layer.cornerRadius = self.familyImage.frame.size.width/2
        self.headPosY = self.headerView.frame.origin.y
        self.headWidth = self.headerView.frame.width
        self.famPosY = familyName.frame.origin.y
        self.collectionHeight = collectionView.frame.height
        lastContentOffset = familyImage.frame.size.height/2
        heightImg = familyImage.frame.size.height
        self.familyImage.layer.cornerRadius = lastContentOffset
        self.familyImage.clipsToBounds = true
        
        NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
            UTILITY_SERVICE.gotoView(view: "RegisterFamilyView", context: self)
            return
        }
        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){_ in
            Utility.Instance().stopLoading(view: self.view)
            self.reloadFamily()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadFamily()
    }
    
    func reloadFamily() -> Void {
        if let family = FAMILY_SERVICE.families.filter({$0.id == (USER_SERVICE.user?.familyActive)! as String}).first{
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = STORAGE_SERVICE.search(url: (family.photoURL?.absoluteString)!) {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        UTILITY_SERVICE.stopLoading(view: self.view)
                        self.familyImage.image = UIImage(data: data)
                    }
                }
            }
            self.familyName.text = family.name ?? "No seleccionada"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = false
        print(scrollView.contentOffset.y)
        print(collectionView.contentOffset.y)
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
                }, completion: nil)
            }
            print("hola")
            }
        }else if (0 >= collectionView.contentOffset.y){
            let percent = 1
            let scale = CGAffineTransform(scaleX: CGFloat(percent), y: CGFloat(percent))
            //self.headerView.frame.origin.y = top
            //DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.familyImage.transform = scale
                self.headerView.frame.size.height = self.heightHeader
                self.collectionView.frame.origin.y = self.heightHeader + self.top
                self.familyName.transform = CGAffineTransform(translationX: 0, y: 0 )
                //self.collectionView.frame.size.height = self.collectionHeight+(self.heightHeader-self.newHeight)
            }, completion: nil)
            /*DispatchQueue.main.async {
             UIView.animate(withDuration: 0.5, delay: 0.9, options: UIViewAnimationOptions.curveEaseOut,animations: {
             self.collectionView.frame.size.height = self.collectionView.frame.size.height+(self.heightHeader-self.newHeight)
             })
             }*/
            //}
            //self.collectionView?.scrollToItem(at: IndexPath(row: 4, section: 0),at: .centeredVertically,animated: true)
            //collectionView.contentOffset.y = 200
        }
        /*else{
            let percent = 1
            let scale = CGAffineTransform(scaleX: CGFloat(percent), y: CGFloat(percent))
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.familyImage.transform = scale
                }, completion: nil)
            }
        }*/
        /*if(100 <= collectionView.contentOffset.y && self.headerView.frame.size.height == 200 && flag == true){
            let percent = 40/self.heightHeader
            let posX: CGFloat = (self.headWidth / -2) + 40
            let posY: CGFloat = ( newHeight ) * -1
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.8, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.familyImage.transform = CGAffineTransform(scaleX: percent, y: percent).concatenating(CGAffineTransform(translationX: posX, y: posY))
                        self.familyName.transform = CGAffineTransform(translationX: posX+60, y: (self.headPosY-self.famPosY) - 5 )
                        self.collectionView.frame.origin.y = self.newHeight
                        self.headerView.frame.size.height = self.newHeight
                    }, completion: nil)
                }
                print("down")
            //self.collectionView?.scrollToItem(at: IndexPath(row: 4, section: 0),at: .centeredVertically,animated: true)
            //collectionView.contentOffset.y = 200
            flag = false
        }
        else if (0 >= collectionView.contentOffset.y && self.headerView.frame.size.height == 60) {
            let percent = 1
            let scale = CGAffineTransform(scaleX: CGFloat(percent), y: CGFloat(percent))
            //self.headerView.frame.origin.y = top
            //DispatchQueue.main.async {
                UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.familyImage.transform = scale
                    self.headerView.frame.size.height = self.heightHeader
                    self.collectionView.frame.origin.y = self.heightHeader + self.top
                    //self.collectionView.frame.size.height = self.collectionHeight+(self.heightHeader-self.newHeight)
                }, completion: nil)
                /*DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, delay: 0.9, options: UIViewAnimationOptions.curveEaseOut,animations: {
                        self.collectionView.frame.size.height = self.collectionView.frame.size.height+(self.heightHeader-self.newHeight)
                    })
                }*/
            //}
            flag = true
        }*/
        // update the new position acquired
        //self.lastContentOffset = scrollView.contentOffset.y
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
