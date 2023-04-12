//
//  AccountViewModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 21.02.2023.
//

import Foundation
import SwiftUI


class AccountViewModel: ObservableObject{
    
    @Published var profile = MUser(name: "", id: "", email: "", image: "")
     
    init() {
        getProfile()
    }

    //Функция, для получение пользователя на экран
    func getProfile(){
        Task { [weak self] in
            self?.profile = try await DBUserService.shared.getProfile()
        }
    }  
}
