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
    //Gustavo, Ricardo, Carlos, Diego, Graciela, Yolanda
    func testChatConversations() -> [chatModel] {
        var chatArray: [chatModel] = []
        chatArray.append(chatModel(name: "Yolanda Mazón", lastMessage: "Me puedes conseguir el acta", date: "3:17p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FmN2e5hhvk3aRL1kEZDOBfuevb952%2Fimages%2F45E5F4CA-5C96-4125-AB16-DB8C92650831.png?alt=media&token=8026fe92-bcf8-4dbe-b4de-cf933cac5b92"))
        chatArray.append(chatModel(name: "Yolanda Mazón", lastMessage: "Me puedes conseguir el acta", date: "3:17p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FmN2e5hhvk3aRL1kEZDOBfuevb952%2Fimages%2F45E5F4CA-5C96-4125-AB16-DB8C92650831.png?alt=media&token=8026fe92-bcf8-4dbe-b4de-cf933cac5b92"))
        chatArray.append(chatModel(name: "Yolanda Mazón", lastMessage: "Me puedes conseguir el acta", date: "3:17p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FmN2e5hhvk3aRL1kEZDOBfuevb952%2Fimages%2F45E5F4CA-5C96-4125-AB16-DB8C92650831.png?alt=media&token=8026fe92-bcf8-4dbe-b4de-cf933cac5b92"))
        return chatArray
    }
    func testGroupConversations() -> [chatModel] {
        var chatArray: [chatModel] = []
        chatArray.append(chatModel(name: "Familia Mazón", lastMessage: "You: Que tal si nos reunimos...", date: "8:17p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/families%2FMaz%C3%B3n%20Escalante-Kg0znUlqrxTxwx0o8fX%2Fimages%2FD2EB3035-B184-4FFA-9588-81F9D96BDADE.png?alt=media&token=eee8b85f-afa7-408c-afdd-7210111cda46"))
        chatArray.append(chatModel(name: "Vacaciones Verano", lastMessage: "Carlos M.: Propongo salir el 14 de...", date: "3:17p.m.", photoUrl: "https://previews.123rf.com/images/hydromet/hydromet1303/hydromet130300008/18516184-playa-con-palmeras-de-coco-y-el-mar-Foto-de-archivo.jpg"))
        return chatArray
    }
    
    func testMembers() -> [chatModel] {
        var chatArray: [chatModel] = []
        chatArray.append(chatModel(name: "Yolanda Mazon", lastMessage: "Conectado en family Office", date: "", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FmN2e5hhvk3aRL1kEZDOBfuevb952%2Fimages%2F45E5F4CA-5C96-4125-AB16-DB8C92650831.png?alt=media&token=8026fe92-bcf8-4dbe-b4de-cf933cac5b92"))
        return chatArray
    }
    
    
        
    
}
