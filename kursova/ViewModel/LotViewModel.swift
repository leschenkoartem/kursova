//
//  LotViewModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 23.02.2023.
//


import Foundation
import SwiftUI


class LotViewModel: ObservableObject{
    
    @EnvironmentObject var profilView: AccountViewModel
    @Published var lotsList = [LotStruct]()
    
    init(lotsList: [LotStruct] = [LotStruct]()) {
        self.lotsList = lotsList
        getLots()
    }
    
    func getLots(){
        DBLotsService.shared.getLots { result in
            switch result{
            case .success(let lots):
                self.lotsList = lots
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
