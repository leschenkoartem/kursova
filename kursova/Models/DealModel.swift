//
//  OrderModel.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import Foundation

struct Deal: Identifiable {
    var id = UUID().uuidString
    var buyer: String
    var salesman: String
    var time: Date
    var price: Int
    var name: String
    
    var representation:[String: Any] {
        var repres = [String:Any]()
        repres["id"] = self.id
        repres["buyer"] = self.buyer
        repres["salesman"] = self.salesman
        repres["time"] = self.time
        repres["price"] = self.price
        repres["name"] = self.name
        
        return repres
    }
}
