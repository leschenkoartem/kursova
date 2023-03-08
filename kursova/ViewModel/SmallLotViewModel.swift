//
//  SmallLotViewModel.swift
//  kursova
//
//  Created by Artem Leschenko on 08.03.2023.
//

import SwiftUI

class SmallLotViewModel : ObservableObject {
    
    
    var lot : LotStruct
    
    init(lot: LotStruct) {
        self.lot = lot
    }
    
    func addToObserve(){
        
        let idUser = AuthService.shared.currentUser!.uid
        
        if !lot.seePeopleId.contains(idUser) {
            lot.seePeopleId.append(idUser)
        }
        //сохраняем в бд
        DatabaseService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
        
        
    }
    
    func dellFromObserve(){
        if let index = lot.seePeopleId.firstIndex(of: AuthService.shared.currentUser!.uid) {
            lot.seePeopleId.remove(at: index)
        }
        //сохраняем в бд
        DatabaseService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
    }
    
    
    
    func addPrice(idUser: String, plusPrice:Int, name:String, email:String) -> String{
        
        var textAlert = ""
        //Dозвращаем деньги прошлому ставщику
        if lot.idCurrentPerson != ""{
            DatabaseService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: +Double(lot.currentPrice)) { error in
                if let error = error {
                    print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                    
                } else {
                    print("Баланс пользователя успешно обновлен")
                    
                }
            }
        }
        
        if lot.idCurrentPerson == idUser{
            lot.currentPrice += plusPrice
            textAlert = "Successful deal. \(plusPrice)$ deducted from your balance"
        }else{
            //изменения лота
            lot.idCurrentPerson = idUser
            lot.currentPrice += plusPrice
            lot.currentPerson = name
            lot.currentEmail = email
            
            textAlert = "Successful deal. \(lot.currentPrice)$ deducted from your balance"
        }
        
        
        
        //изменения счёта пользователя
        DatabaseService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: -Double(lot.currentPrice)) { error in
            if let error = error {
                print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                
            } else {
                print("Баланс пользователя успешно обновлен")
                
            }
        }
        
        
        //обновляет данные лота
        DatabaseService.shared.changeCurentDataLot(LotId: lot.id, currentPrice: lot.currentPrice, currentPerson: lot.currentPerson, idCurrentPerson: idUser, currentEmail: lot.currentEmail)
        
        //Добавление в наблюдаемые
        if !lot.seePeopleId.contains(idUser) {
            lot.seePeopleId.append(idUser)
        }
        
        DatabaseService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
        
        
        
        return textAlert
 
    }
    
    func finishLot(idUser: String, plusPrice:Int, name:String, email:String) -> String{
        
        var textAlert = ""
        //Если есть текущий пользователь, передаём деньги создателю
        if lot.idCurrentPerson != ""{
            DatabaseService.shared.updateBalance(for: lot.idCreator, amountToAdd: Double(lot.currentPrice)) { error in
                if let error = error {
                    print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                    
                } else {
                    print("Баланс пользователя успешно обновлен")
                    
                }
            }
            
            textAlert = "Successfully closed the lot. Your balance is replenished by \(lot.currentPrice)$"
        }else{
            //если нет, то просто выводим ошибку
            textAlert = "Successfully closed the lot. Your balance is replenished by 0$"
            
        }
        
        DatabaseService.shared.deleteLotPhoto(LotId: lot.id)
        DatabaseService.shared.deleteLotData(LotId: lot.id)
        
        
        return textAlert
     
    }
    
    
    func delLot(idUser: String, plusPrice:Int, name:String, email:String) -> String{
        
        var textAlert = ""
        //Если есть текущий пользователь, возвразаем ему деньги
        if lot.idCurrentPerson != ""{
            DatabaseService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: Double(lot.currentPrice)) { error in
                if let error = error {
                    print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                    
                } else {
                    print("Баланс пользователя успешно обновлен")
                    
                }
            }
            
            textAlert = "Lot removed. Money returned to:\n \(lot.currentPerson)\n\(lot.currentEmail)"
            
        }else{
            //если нет - просто удаляем
            textAlert = "Lot removed."
            
        }
        
       
        DatabaseService.shared.deleteLotPhoto(LotId: lot.id)
        DatabaseService.shared.deleteLotData(LotId: lot.id)
        
        
        
        
        return textAlert
    }
}

