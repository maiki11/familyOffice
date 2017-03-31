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
        dateArray.append(DateModel(title: "Reunión con el licenciado", description: "Lic. Gutierrez", date: "2017 03 23", hour: "10:45", priority: 2, members: []))
        dateArray.append(DateModel(title: "Junta Familiar", description: "Ninguna", date: "2017 03 24", hour: "9:45", priority: 3, members: ["weNFXUj0WUOVzA5cglccb9TpvPA2","wJO9STJUBDfLmIyVfZ013EUwRe83"]))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 23", hour: "10:00", priority: 2, members: ["yZVtibNd8xZWiiUx7rEr4g3WGNl2"]))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 24", hour: "10:00", priority: 2, members: ["ySl0uVDQyZWZegBebbOwblspmdu1"]))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 25", hour: "10:00", priority: 2, members: ["weNFXUj0WUOVzA5cglccb9TpvPA2", "wJO9STJUBDfLmIyVfZ013EUwRe83"]))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 26", hour: "10:00", priority: 2, members: []))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 27", hour: "10:00", priority: 2, members: []))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 28", hour: "10:00", priority: 2, members: []))
        dateArray.append(DateModel(title: "Tomar Pastilla", description: "Paracetamol", date: "2017 03 29", hour: "10:00", priority: 2, members: []))
        
        return dateArray
    }
    //Gustavo, Ricardo, Carlos, Diego, Graciela, Yolanda
    func testChatConversations() -> [chatModel] {
        var chatArray: [chatModel] = []
        chatArray.append(chatModel(name: "Gustavo Mazón", lastMessage: "Me puedes conseguir el acta", date: "3:17p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FEuzrwwzkZbW4mgxFfUwrD7qgRv53%2Fimages%2F9630C628-174F-4F52-B00B-EABFA5EF15D4.png?alt=media&token=747a65f7-fb27-44c8-bb0b-e5c0f9978f14"))
        chatArray.append(chatModel(name: "Diego Mazon", lastMessage: "¿Cómo estás?", date: "5:34p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2F8CqVuy5NviNEIA3heInjqRB19qY2%2Fimages%2F85E5AA85-7421-4B68-8345-DC996C2314F2.png?alt=media&token=4ffcb121-59fc-47ac-bbf2-2f34d16e2432"))
        chatArray.append(chatModel(name: "Carlos Mazon", lastMessage: "Tienes el número de...", date: "8:50p.m.", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FySl0uVDQyZWZegBebbOwblspmdu1%2Fimages%2F84335E74-3811-469D-96D1-6C024D00D1EE.png?alt=media&token=cfec4632-7ca4-46ed-b49a-b61cf6839246"))
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
        chatArray.append(chatModel(name: "Gustavo Mazon", lastMessage: "Conectado en family Office", date: "", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FEuzrwwzkZbW4mgxFfUwrD7qgRv53%2Fimages%2F9630C628-174F-4F52-B00B-EABFA5EF15D4.png?alt=media&token=747a65f7-fb27-44c8-bb0b-e5c0f9978f14"))
        chatArray.append(chatModel(name: "Ricardo Mazon", lastMessage: "Conectado en family Office", date: "", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FwJO9STJUBDfLmIyVfZ013EUwRe83%2Fimages%2FEA27782A-D92E-454F-B782-ED2A748F4CB2.png?alt=media&token=8dfd9777-aec9-43fd-9241-2fb300dfd3c3"))
        chatArray.append(chatModel(name: "Graciela Mazon", lastMessage: "Conectado en family Office", date: "", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FsYjBSitcGlSDRKoP1maAvd1RqUs2%2Fimages%2F3A7A9662-DC83-442C-A76E-6DF9D8DBEE25.png?alt=media&token=da2fe96d-2011-4952-8b30-f8ecacfdc0fb"))
        chatArray.append(chatModel(name: "Diego Mazon", lastMessage: "Conectado en family Office", date: "", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2F8CqVuy5NviNEIA3heInjqRB19qY2%2Fimages%2F85E5AA85-7421-4B68-8345-DC996C2314F2.png?alt=media&token=4ffcb121-59fc-47ac-bbf2-2f34d16e2432"))
        chatArray.append(chatModel(name: "Carlos Mazon", lastMessage: "Conectado en family Office", date: "", photoUrl: "https://firebasestorage.googleapis.com/v0/b/familyoffice-6017a.appspot.com/o/users%2FySl0uVDQyZWZegBebbOwblspmdu1%2Fimages%2F84335E74-3811-469D-96D1-6C024D00D1EE.png?alt=media&token=cfec4632-7ca4-46ed-b49a-b61cf6839246"))
        return chatArray
    }
    
    
        
    
}
