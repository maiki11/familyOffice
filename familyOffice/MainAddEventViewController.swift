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
    
    var event: Event!
    var members: [String]! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        setupMenuBar()
        setupCollectionView()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func update()  {
        guard validation() else {
            return
        }
        Constants.Services.EVENT_SERVICE.update("events/\(event.id!)", value: event.toDictionary() as! [AnyHashable : Any], callback: { response in
            if response is String {
                //Actualización local del evento que se acaba de modificar
                if let index = Constants.Services.EVENT_SERVICE.events.index(where: {$0.id == self.event.id}){
                    Constants.Services.EVENT_SERVICE.events[index] = self.event
                    //Verifica y hace match si los miembros que se actualizaron estan o no con los viejos para eliminarles o no el evento.
                    for uid in self.members {
                        if !self.event.members.contains(where: {$0 == uid}) {
                            //Crear metodo para remover evento de usuario
                            Constants.FirDatabase.REF_USERS.child("\(uid)/events/\(self.event.id!)").removeValue()
                        }
                    }
                     _ = self.navigationController?.popViewController(animated: true)
                }
                
                //Posible aviso de actualización y verficación de que miembros ya no se encuentran.
            }
        })
    }
    func saveEvent(){
        guard validation() else {
            return
        }
        
        let key = Constants.FirDatabase.REF.childByAutoId().key
        event.id = key
       
        event.members.append(Constants.Services.USER_SERVICE.users[0].id)
        Constants.Services.EVENT_SERVICE.insert("events/\(key)", value: event.toDictionary(), callback: { response in
            if response is String {
                Constants.Services.EVENT_SERVICE.events.append(self.event)
            }
        })
    }
    func validation() -> Bool{
        guard let cell : addEvent = self.collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as? addEvent else {
            print("Error al asignar la celda")
            return false
        }
        
        guard (!event.title.isEmpty) else {
            Constants.Services.ANIMATIONS.shakeTextField(txt: cell.xib.titleTextField)
            return false
        }
        
        guard (!event.date.isEmpty) else {
            Constants.Services.ANIMATIONS.shakeTextField(txt: cell.xib.dateStartTxtField)
            return false
        }
        guard (!event.endDate.isEmpty) else {
            Constants.Services.ANIMATIONS.shakeTextField(txt: cell.xib.endDateTxtField)
            return false
        }

        return true
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
        self.bind(event: event!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeActions), name: Constants.NotificationCenter.USER_NOTIFICATION, object: nil)

        if !event.id.isEmpty {
            let updateButton = UIBarButtonItem(title: "Actualizar", style: .plain, target: self, action:#selector(self.update))
            updateButton.tintColor = #colorLiteral(red: 1, green: 0.1757333279, blue: 0.2568904757, alpha: 1)
            navigationItem.rightBarButtonItems = [updateButton]
            self.members = event.members
            
        }else{
            let savebutton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action:#selector(self.saveEvent))
            savebutton.tintColor = #colorLiteral(red: 1, green: 0.1757333279, blue: 0.2568904757, alpha: 1)
            navigationItem.rightBarButtonItems = [savebutton]
        }
    }
    func observeActions() -> Void {
        guard let cell:MapAddEventTable = self.collectionView?.cellForItem(at: IndexPath(item: 1, section: 0)) as? MapAddEventTable else{
            return
        }
        guard let tablecell:memberCollectionTableViewCell = cell.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? memberCollectionTableViewCell else {
            return
        }
        tablecell.collectionView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
         NotificationCenter.default.removeObserver(self)
        
    }
}



