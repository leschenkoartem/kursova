//
//  AcuctionViewModel.swift
//  kursova
//
//  Created by Artem Leschenko on 22.03.2023.
//

import Foundation

class AuctionViewModel: ObservableObject {
    
    ///Для фільтру ціни
    @Published  var priceFilterOn = false
    @Published  var minPrice = ""
    @Published  var maxPrice = ""
    ///Для фільтру поточного користувача
    @Published  var currentFilterOn = false
    ///Для фільтру власника користувача
    @Published  var filterCrearor = UserDefaults.standard.bool(forKey: "filterCrearor")
    ///Для фільтру послідовності
    @Published  var observedQueue = 0
    ///Для пошукового слова
    @Published  var searchInputWord = ""
    
    ///Для оптимізації пошуку по слову
    var searchWord:String{
        get{return searchInputWord == "" ? " ": searchInputWord}
    }
    
    func getQueue(observedQueue: Int, list: [LotStruct]) -> [LotStruct]{
        
        switch observedQueue{
        case 0:
            return list.sorted(by: { $0.date > $1.date })
        case 1:
            return list.sorted(by: { $0.date < $1.date })
        case 3:
            return list.sorted(by: { $0.seePeopleId.count > $1.seePeopleId.count })
        case 4:
            return list.sorted(by: { $0.seePeopleId.count < $1.seePeopleId.count })
        default:
            return list.sorted(by: { $0.date > $1.date })
        }
    }
    
    func getLot(lot: LotStruct) -> LotStruct?{
        
        let lot = lot
        
        //Фільтри на стороні клієнта
        if (lot.mainText.uppercased().contains(searchWord.uppercased()) || searchWord.contains(lot.id))
                                && (priceFilterOn ? (lot.currentPrice >= Int(minPrice) ?? 0 && lot.currentPrice <= Int(maxPrice) ?? 1000000) : true)
                                && (currentFilterOn ? (lot.currentPerson == "None"): true)
                                && (filterCrearor ? lot.idCreator != AuthService.shared.currentUser!.uid: true) { //Фильтр даты
                                return lot
        } else {
            return nil
        }
    }
    
}
