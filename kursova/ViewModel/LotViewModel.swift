//
//  LotViewModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 23.02.2023.
//


import Foundation
import SwiftUI


class LotViewModel: ObservableObject{
    
    
    @Published var lots_info = [Lot_str]()
    
    
    init(lots_info: [Lot_str] = [Lot_str]()) {
        self.lots_info = lots_info
        getLots()
        print("")
    }
    
    func getLots(){
        DatabaseService.shared.getLots { result in
            switch result{
            case .success(let lots):
                self.lots_info = lots
                print("fkay")
                print(lots.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
