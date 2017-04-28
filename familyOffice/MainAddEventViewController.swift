//
//  AddEventViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 04/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMenuBar: class {
    func scrollMenuIndex(_ menuIndex: Int)
}
protocol ShareEvent: class {
    var event: Event! { get set }
    
}
extension ShareEvent {
    func bind(event: Event) {
        self.event = event
    }
}

class AddEventViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HandleMenuBar, ShareEvent{
    var resultSearchController: UISearchController!
    
    var event: Event! = Event(id: "",title: "", description: "", date: Date().string(with: .dayMonthYearHourMinute), endDate: Date().addingTimeInterval(60 * 60).string(with: .dayMonthYearHourMinute) , priority: 0, members: [], reminder: Date().addingTimeInterval(60*60*(-1)).string(with: .dayMonthYearHourMinute))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        setupMenuBar()
        setupCollectionView()
        
        let savebutton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action:#selector(self.saveEvent))
        savebutton.tintColor = #colorLiteral(red: 1, green: 0.1757333279, blue: 0.2568904757, alpha: 1)
        navigationItem.rightBarButtonItems = [savebutton]
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveEvent(){
        let cell = self.collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as! addEvent
       
        guard (!event.title.isEmpty) else {
           Constants.Services.ANIMATIONS.shakeTextField(txt: cell.xib.titleTextField)
           return
        }
        
        guard (!event.date.isEmpty) else {
            Constants.Services.ANIMATIONS.shakeTextField(txt: cell.xib.dateStartTxtField)
            return
        }
        
        let key = Constants.FirDatabase.REF.childByAutoId().key
        event.id = key
       
        event.members.append(Constants.Services.USER_SERVICE.users[0].id)
        Constants.Services.EVENT_SERVICE.insert("events/\(key)", value: event.toDictionary(), callback: { response in
            if response is String {
                Constants.Services.EVENT_SERVICE.events.append(self.event)
                for uid in self.event.members {
                    Constants.Services.EVENT_SERVICE.addEventToMember(uid: uid, eid: response as! String)
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        })
        

    }

    private func setupCollectionView() {
        if let flowlayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 20
        }
        self.collectionView!.register(addEvent.self, forCellWithReuseIdentifier: "cellId")
        self.collectionView!.register(MapAddEventTable.self, forCellWithReuseIdentifier: "mapcell")
        
        self.collectionView!.contentInset = UIEdgeInsets(top: 130, left: 10, bottom: 100, right: 10)
        self.collectionView!.scrollIndicatorInsets = UIEdgeInsets(top: 130, left: 10, bottom: 100, right: 10)
        
        collectionView?.isPagingEnabled = true
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.array = ["INFO","MAPA"]
        return mb
    }()
    private func setupMenuBar() {
        menuBar.addEventController = self
        menuBar.setupHorizontalBar()
        self.view.addSubview(menuBar)
        self.view.addContraintWithFormat(format: "H:|[v0]|", views: menuBar)
        self.view.addContraintWithFormat(format: "V:|[v0(50)]|", views: menuBar)
        menuBar.handleMapSearchDelegate = self
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! addEvent
            cell.shareEventDelegate = self
            cell.addView()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapcell", for: indexPath) as! MapAddEventTable
            cell.shareEventDelegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-20, height: view.frame.height-150)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorContraint?.constant = scrollView.contentOffset.x / CGFloat(menuBar.array.count)
    }
    
    func scrollMenuIndex(_ menuIndex: Int) -> Void {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
}



