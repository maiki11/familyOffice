//
//  Location.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 04/05/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Firebase

struct Location {
    
    static let ktitle = "title"
    static let ksubtitle = "subtitle"
    static let klatitude = "latitude"
    static let klongitude = "longitude"
    
    var title : String!
    var subtitle : String!
    var latitude : Double!
    var longitude: Double!
    
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.subtitle = subtitle
        self.title = title
    }
    
    init(snapshot: NSDictionary) {
        self.title = Constants.Services.UTILITY_SERVICE.exist(field: Location.ktitle, dictionary: snapshot)
        self.subtitle = Constants.Services.UTILITY_SERVICE.exist(field: Location.ksubtitle, dictionary: snapshot)
        self.latitude = Constants.Services.UTILITY_SERVICE.exist(field: Location.klatitude, dictionary: snapshot)
        self.longitude = Constants.Services.UTILITY_SERVICE.exist(field: Location.klongitude, dictionary: snapshot)
        
    }
    
    func toDictionary() -> NSDictionary {
        
        return [
            Location.ktitle : self.title,
            Location.ksubtitle : self.subtitle,
            Location.klongitude : self.longitude,
            Location.klatitude : self.latitude
        ]
        
    }
    
}
