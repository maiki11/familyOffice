//
//  ShowEventViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/05/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import MapKit
class ShowEventViewController: UIViewController, EventBindable {
    var event: Event?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    let locationManager = CLLocationManager()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    var remimberLabel: UILabel!
    var protocolNotification: NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.collectionView.register(UINib(nibName: "MemberInviteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "memberCell")
       
        // Do any additional setup after loading the view.
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bind(event: event!)
        
        self.collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeActions), name: Constants.NotificationCenter.USER_NOTIFICATION, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func observeActions() -> Void {
         self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        dropPinZoomIn()
        self.collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func dropPinZoomIn(){
        
        guard let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (event?.location?.latitude)!, longitude: (event?.location?.longitude)!) as? CLLocationCoordinate2D else{
            print("Algo salio mal al buscar la coordenada")
            return
        }
 
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = event?.location?.title
        annotation.subtitle = event?.location?.subtitle
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

}

extension ShowEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (event?.members.count)!
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberInviteCollectionViewCell
        let id : String = (event?.members[indexPath.row])!
        if let user = Constants.Services.USER_SERVICE.users.filter({$0.id == id }).first {
            cell.bind(userModel: user)
        }else{
            Constants.Services.REF_SERVICE.valueSingleton(ref: "users/\(id)")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
}
extension ShowEventViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}
