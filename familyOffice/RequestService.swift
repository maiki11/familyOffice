//
//  RequestService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 07/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Toast_Swift

protocol RequestService {
    

    func insert(_ ref: String, value: Any, callback: @escaping ((_ results: Any) -> Void))
    func delete(_ ref: String, callback: @escaping ((_ results: Any) -> Void))
    func update(_ ref: String,value:  [AnyHashable : Any], callback: @escaping ((_ results: Any) -> Void))
    
}
