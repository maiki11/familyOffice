//
//  FamilyViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 13/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.


import UIKit
import FirebaseAuth

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate  {
    let center = NotificationCenter.default
    var members : [User] = []
    var family : Family?
    var index: Int? = nil
    var localeChangeObserver : [NSObjectProtocol] = []
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var membersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(self.family?.photoURL?.isEmpty)! {
            self.imageFamily.loadImage(urlString: (self.family?.photoURL!)!)
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        membersTable.addGestureRecognizer(lpgr)
        membersTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        let addButton : UIBarButtonItem = UIBarButtonItem(title: "Agregar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(addMemberScreen(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = family?.name
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        members = []
        self.membersTable.reloadData()
        verifyMembersOffLine()
        
        Constants.Services.REF_SERVICE.valueSingleton(ref: "families/\((family?.id)!)")
        Constants.Services.REF_SERVICE.chilRemoved(ref: "families/\((family?.id)!)/members")
        Constants.Services.REF_SERVICE.chilAdded(ref: "families/\((family?.id)!)/members")
        
        
        localeChangeObserver.append( center.addObserver(forName: Constants.NotificationCenter.USERS_NOTIFICATION, object: nil, queue: nil){ obj in
            if let user : User = obj.object as? User {
                self.addMember(id: user.id)
            }
        })
         localeChangeObserver.append(center.addObserver(forName: Constants.NotificationCenter.USERUPDATED_NOTIFICATION, object: nil, queue: nil){ obj in
            if let id : String = obj.object as? String {
                if let index = self.members.index(where: {$0.id == id }) {
                    self.members[index] = Constants.Services.USER_SERVICE.users.first(where: {$0.id == id})!
                    self.membersTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        })
        localeChangeObserver.append(center.addObserver(forName: Constants.NotificationCenter.FAMILYREMOVED_NOTIFICATION, object: nil, queue: nil){index in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
         localeChangeObserver.append(center.addObserver(forName: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil, queue: nil){ obj in
            if let user : [String:String] = obj.object as? [String:String] {
                if user.first?.value == "removed"{
                    
                    self.removeMembers(key: (user.first?.key)!)
                }else if user.first?.value == "added" {
                    self.addMember(id: (user.first?.key)!)
                }
            }
        })
         localeChangeObserver.append(center.addObserver(forName: Constants.NotificationCenter.FAMILYUPDATED_NOTIFICATION, object: nil, queue: nil){ notification in
            if let index : Int = notification.object as? Int {
                self.family = Constants.Services.FAMILY_SERVICE.families[index]
                self.imageFamily.loadImage(urlString: (self.family?.photoURL)!)
                self.navigationItem.title = self.family?.name
            
            }
        })
    }

    func removeMembers(key: String) -> Void {
        if let index = self.members.index(where: {$0.id == key}) {
            self.members.remove(at: index)
            Constants.Services.REF_SERVICE.remove(ref: "users/\(key)")
            self.membersTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.top)
        }
    }
    func verifyMembersOffLine() -> Void {
        let family = (Constants.Services.FAMILY_SERVICE.families.first(where: {$0.id == self.family?.id})?.members)!
        for item in family{
            addMember(id: item )
        }
    }
    
    func addMember(id: String) -> Void {
        if let user = Constants.Services.USER_SERVICE.users.filter({$0.id == id}).first {
           if !self.members.contains(where: {$0.id == user.id}){
                self.members.append(user)
                Constants.Services.REF_SERVICE.childChanged(ref: "users/\(id)")
                self.membersTable.insertRows(at: [NSIndexPath(row: self.members.count-1, section: 0) as IndexPath], with: .fade)
            }
            //self.addMembers(user: user)
        }else{
            Constants.Services.REF_SERVICE.valueSingleton(ref: "users/\(id)")
        }
    }
    
    func addMemberScreen(sender: UIBarButtonItem) -> Void {
        self.performSegue(withIdentifier: "addMembersScreen", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for item in self.members {
            Constants.Services.REF_SERVICE.remove(ref: "users/\((item.id)!)")
        }
        members = []
        Constants.Services.REF_SERVICE.remove(ref: "families/\((family?.id)!)/members")
        for observer in localeChangeObserver {
            center.removeObserver(observer)
        }
        self.localeChangeObserver.removeAll()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FamilyMemberTableViewCell
        let member = self.members[indexPath.row]
        cell.name.text = member.name
        cell.memberImage.image = #imageLiteral(resourceName: "profile_default")
        if !member.photoURL.isEmpty {
            cell.memberImage.loadImage(urlString: member.photoURL)
        }
        
        cell.phone.text = member.phone
        
        if(Constants.Services.FAMILY_SERVICE.families.filter({$0.id == family?.id}).first?.admin == member.id){
            cell.adminlabel.isHidden = false
        }else{
            cell.adminlabel.isHidden = true
        }
        
        return cell
    }
    
    //Long press
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureReconizer.location(in: self.membersTable)
        let indexPath = self.membersTable?.indexPathForRow(at: point)
        
        if (indexPath != nil && (indexPath?.row)! < members.count) {
            switch gestureReconizer.state {
            case .began:
                
                let user = members[(indexPath?.row)!]
                if(user.id == FIRAuth.auth()?.currentUser?.uid){
                    break
                }
                // create the alert
                let alert = UIAlertController(title: user.name, message: "¿Qué deseas hacer?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ver Perfil", style: UIAlertActionStyle.default, handler: {action in
                    
                    if let index = Constants.Services.USER_SERVICE.users.index(where: {$0.id == user.id}) {
                        self.index = index
                        self.performSegue(withIdentifier: "ProfileSegue", sender: nil)

                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                if(family?.admin == FIRAuth.auth()?.currentUser?.uid){
                    alert.addAction(UIAlertAction(title: "Remover de la familia", style: UIAlertActionStyle.destructive, handler:  { action in
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                            //ELiminar usuario de la familia
                            Constants.Services.FAMILY_SERVICE.remove(snapshot: user.id, id: (self.family?.id!)!)
                        }
                    }))
                }
                // show the alert
                self.present(alert, animated: true, completion: nil)
                break
            case .ended:
                print("termine")
                break
            default:
                break
            }
        }
    }
    @IBAction func handleExitFamily(_ sender: UIButton) {
        Constants.Services.FAMILY_SERVICE.exitFamily(family: family!, uid: (FIRAuth.auth()?.currentUser?.uid)!)
        Constants.Services.UTILITY_SERVICE.gotoView(view: "TabBarControllerView", context: self)
       
    }
 
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addMembersScreen"){
            let viewController = segue.destination as! AddMembersTableViewController
            viewController.family = family!
        }else if segue.identifier == "ProfileSegue" {
            let viewController = segue.destination as! ProfileUserViewController
            viewController.index  = index!
        }
    }
    
}
