//
//  repeatModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import Foundation

struct repeatModel {
    static let kEach = "each"
    static let kEnd = "endRepeat"
    var each: String!
    var end: String!
    
    init(each: String, end: String) {
        self.end = end
        self.each = each
    }
    
    init(snapshot: NSDictionary) {
        self.each = service.UTILITY_SERVICE.exist(field: repeatModel.kEach, dictionary: snapshot)
        self.each = service.UTILITY_SERVICE.exist(field: repeatModel.kEnd, dictionary: snapshot)
    }
    
    func toDictionary() -> NSDictionary {
        
        return [
            repeatModel.kEach : self.each,
            repeatModel.kEnd: self.end
        ]
    }
}
