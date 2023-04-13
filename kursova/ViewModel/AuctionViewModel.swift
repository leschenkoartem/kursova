//
//  AcuctionViewModel.swift
//  kursova
//
//  Created by Artem Leschenko on 22.03.2023.
//

import Foundation

class AuctionViewModel{
    
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
    
    func getLot(priceFilterOn: Bool,
                dateFilterOn: Bool,
                currentFilterOn: Bool,
                filterCrearor: Bool,
                lot: LotStruct,
                searchWord: String,
                selectedDate: Date,
                minPrice: String,
                maxPrice: String ) -> LotStruct?{
        
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
