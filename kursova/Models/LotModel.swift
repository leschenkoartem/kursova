//
//  LotModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 23.02.2023.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import SwiftUI


struct Lot_str: Identifiable, Equatable{
    //Структура лот
    
    var id: String = UUID().uuidString
    var idCreator:String
    var idCurrentPerson:String
    var mainText:String
    var currentPrice:Int
    var currentPerson:String = "None"
    var currentEmail:String = "..."
    var informationText:String
    var date:Date
    var seePeopleId:[String]
    
    
    //функция подготовки данных для передачи в бд
    var representation:[String: Any]{
        var repres = [String:Any]()
        repres["id"] = self.id
        repres["idCurrentPerson"] = self.idCurrentPerson
        repres["mainText"] = self.mainText
        repres["idCreator"] = AuthService.shared.currentUser!.uid
        repres["currentPrice"] = self.currentPrice
        repres["currentPerson"] = self.currentPerson
        repres["currentEmail"] = self.currentEmail
        repres["informationText"] = self.informationText
        repres["date"] = self.date
        repres["seePeopleId"] = self.seePeopleId
        
        return repres
    }
    
    
    
}
