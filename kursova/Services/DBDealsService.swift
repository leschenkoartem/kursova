//
//  DBDealsService.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseStorage


class DBDealsService{
    
    
    static var shared = DBDealsService()
    //1) делаем переменную обращения датабазы 2) Делаем ссылку на список "users"
    let dB = Firestore.firestore()
    
    var dealsRef:CollectionReference {
        return dB.collection("deals")
    }
    
    //Делаем инит приватным для запрета создания еще одного
    private init(){ }
    
    func getDeals() async throws -> [Deal] {
        let querySnapshot = try await dealsRef.getDocuments()
        let lots = try querySnapshot.documents.compactMap { doc -> Deal? in
            guard let id = doc["id"] as? String,
                  let buyer = doc["buyer"] as? String,
                  let salesman = doc["salesman"] as? String,
                  let name = doc["name"] as? String,
                  let price = doc["price"] as? Int,
                  let time = doc["time"] as? Timestamp else { throw AppError.dataNotFound }
            return Deal(id: id, buyer: buyer, salesman: salesman, time: time.dateValue(), price: price, name: name)
        }
        return lots
    }
    
    func addDeal(deal: Deal) {
        dealsRef.document(deal.id).setData(deal.representation) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(self.dealsRef)")
            }
        }
    }
}
