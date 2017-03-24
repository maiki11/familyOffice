//
//  testFile.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//


class testFile {
    
    func testDate() -> [DateModel] {
        var dateArray : [DateModel] = []
        dateArray.append(DateModel(title: "Reunión con el licenciado", description: "Lic. Gutierrez", date: "2017 03 23", hour: "10:45", priority: 2))
        dateArray.append(DateModel(title: "Junta Familiar", description: "Ninguna", date: "2017 03 24", hour: "9:45", priority: 3))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 23", hour: "10:00", priority: 2))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 24", hour: "10:00", priority: 2))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 25", hour: "10:00", priority: 2))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 26", hour: "10:00", priority: 2))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 27", hour: "10:00", priority: 2))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 28", hour: "10:00", priority: 2))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 29", hour: "10:00", priority: 2))
        
        return dateArray
    }
    
    
}
