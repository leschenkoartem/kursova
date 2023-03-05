//
//  AccountViewModel.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 21.02.2023.
//

import Foundation
import SwiftUI


class AccountViewModel: ObservableObject{
    
    @Published var profile = User_str(name: "", id: "xwdx", email: "", image: "")
     
    init() {
        self.getProfile()
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
