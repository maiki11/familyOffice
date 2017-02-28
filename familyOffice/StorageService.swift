//
//  storageService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 02/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation

class StorageService {
    public var storage : NSMutableDictionary = [:]
    
    private init() {
    }
    
    public static func Instance() -> StorageService {
        return instance
    }
    
    private static let instance : StorageService = StorageService()
    
    func save(url: String, data: Data?) -> Void {
        
        if(data != nil){
            self.storage.setValue(data, forKey: url)
        }else{
            DispatchQueue.global(qos: .default).async {
                if let data = NSData(contentsOf: URL(string: url)!){
                    DispatchQueue.main.async {
                        self.storage.setValue(data , forKey: url)
                    }
                }
                
            }
        }
        
    }
    
    func search(url: String) -> Data? {
        if (url != "" && storage.object(forKey: url) == nil) {
            save(url: url, data: nil)
        }else if (url == "") {
            return nil
        }
        return storage.object(forKey: url) as! Data?
    }
    
    
    func clear() -> Void {
        self.storage.removeAllObjects()
    }
}
