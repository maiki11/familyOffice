//
//  MapTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 10/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import MapKit
import MultiAutoCompleteTextSwift

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapTableViewCell: UITableViewCell {
    
    weak var shareEventDelegate : ShareEvent!
    var matchingItems: [MKMapItem] = []
    @IBOutlet weak var searchTextField: MultiAutoCompleteTextField!
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin: MKPlacemark?
    var timeZone: TimeZone!
    let storyboard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
    
    let locationManager = CLLocationManager()
    
    func setupLocation() -> Void {
        dropPinZoomIn(event: shareEventDelegate.event)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:(#selector(self.addAnnotation(gestureRecognizer:))))
        gestureRecognizer.minimumPressDuration = 2.0
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        searchTextField.onSelect = {[weak self] str, indexPath in
            guard let selectedItem = self?.matchingItems[(indexPath as NSIndexPath).row].placemark else {
                return
            }
            self?.searchTextField.text = str
            self?.dropPinZoomIn(selectedItem)
            
        }
        
        searchTextField.onTextChange = {[weak self] text in
            if text.characters.count > 1 {
                self?.updateSearchResults(text) { results in
                    self?.searchTextField.autoCompleteTokens.removeAll()
                    results.forEach {
                        self?.searchTextField.autoCompleteTokens.append($0)
                    }
                }
            }
        }
    }
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    let pm = placemarks?[0]
                    annotation.title = (pm?.thoroughfare!)! + ", " + (pm?.subThoroughfare)!
                    annotation.subtitle = pm?.subLocality
                    self.mapView.addAnnotation(annotation)
                    self.shareEventDelegate.event.location = Location(title: annotation.title!, subtitle: annotation.subtitle!, latitude: (pm?.location?.coordinate.latitude)!, longitude: (pm?.location?.coordinate.longitude)!)
                }
            })
        }
    }
    
    fileprivate func updateSearchResults(_ place: String, callback: @escaping ((_ results: [MultiAutoCompleteToken]) -> Void)) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = place
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = []
            var countryNames : [MultiAutoCompleteToken] = []
            for item in response.mapItems {
                countryNames.append(MultiAutoCompleteToken(top: item.name!, subTexts: self.parseAddress(item.placemark)))
            }
            self.matchingItems = response.mapItems
            DispatchQueue.main.async {
                
                callback(countryNames)
            }
        }
        
        
    }
    // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func parseAddress(_ selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
}
extension MapTableViewCell : CLLocationManagerDelegate {
    
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
extension MapTableViewCell: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        timeZone = placemark.timeZone
        shareEventDelegate.event.location = Location(title: annotation.title!, subtitle: annotation.subtitle!, latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
       
    }
    
    func dropPinZoomIn(event: Event){
        
        if event.location != nil {
            
            guard let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (event.location?.latitude)!, longitude: (event.location?.longitude)!) as? CLLocationCoordinate2D else{
                print("Algo salio mal al buscar la coordenada")
                return
            }
            
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = event.location?.title
            annotation.subtitle = event.location?.subtitle
            
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(annotation.coordinate, span)
            mapView.setRegion(region, animated: true)}
        
    }
}


