//
//  AccountViewModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 21.02.2023.
//

import Foundation
import SwiftUI


class AccountViewModel: ObservableObject{
    
    @Published var profile = MainUser(name: "", id: "", email: "", image: "")
     

    
    init() {
        getProfile()
    }
    
   
    
    //Функция, для получение пользователя на экран
    func getProfile(){
        DatabaseService.shared.getProfile { result in
            switch result{
            case .success(let user):
                self.profile = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }  
}
