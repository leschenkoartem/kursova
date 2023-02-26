//
//  userModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import Foundation
import FirebaseAuth

struct User_str:Identifiable{
    //Структура пользователя
    var name:String
    var id:String
    var balance = Int.random(in: 10000..<50001)
    var email:String
    
    //функция подготовки данных для передачи в бд
    var representation:[String: Any]{
        var repres = [String:Any]()
        repres["id"] = self.id
        repres["balance"] = self.balance
        repres["email"] = self.email
        repres["name"] = self.name
        return repres
    }
}
