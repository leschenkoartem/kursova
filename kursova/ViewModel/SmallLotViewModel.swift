//
//  SmallLotViewModel.swift
//  kursova
//
//  Created by Artem Leschenko on 08.03.2023.
//

import SwiftUI

class SmallLotViewModel : ObservableObject {
    
    //Для ошибки
    @Published var showAletr = false
    @Published var showDialog = false
    @Published var textDialog = ""
    @Published var variationdialog = "delete"
    
    var profilView: AccountViewModel
    
    @EnvironmentObject var dealView: DealsViewModel
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    @Published var textAlert = ""
    
    var idUser = AuthService.shared.currentUser!.uid
    
    var simId:Bool {
        get {
            return lot.idCreator == idUser
        }
    }
    
    var lot : LotStruct
    
    @Published var plusPrice = 500 {
        didSet {
            if plusPrice < 500{
                plusPrice = 500
            }
        }
    }
    
    init(lot: LotStruct, profilView: AccountViewModel) {
        self.lot = lot
        self.profilView = profilView
    }
    
    func addToObserve(){
        let idUser = AuthService.shared.currentUser!.uid
        
        if !lot.seePeopleId.contains(idUser) {
            lot.seePeopleId.append(idUser)
        }
        //сохраняем в бд
        DBLotsService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
    }
    
    func dellFromObserve(){
        if let index = lot.seePeopleId.firstIndex(of: AuthService.shared.currentUser!.uid) {
            lot.seePeopleId.remove(at: index)
        }
        //сохраняем в бд
        DBLotsService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
    }
    
    
    
    func addPrice() {
        //Dозвращаем деньги прошлому ставщику
        if lot.idCurrentPerson != ""{
            DBUserService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: +Double(lot.currentPrice)) { error in
                if let error = error {
                    print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                } else {
                    print("Баланс пользователя успешно обновлен")
                }
            }
        }
        if lot.idCurrentPerson == idUser {
            lot.currentPrice += plusPrice
            textAlert = "Successful deal. ".localized(language) +  String(plusPrice) + "$ deducted from your balance".localized(language)
        }else{
            //изменения лота
            lot.idCurrentPerson = idUser
            lot.currentPrice += plusPrice
            lot.currentPerson = profilView.profile.name
            lot.currentEmail = profilView.profile.email
            textAlert = "Successful deal. ".localized(language) +  String(lot.currentPrice) + "$ deducted from your balance".localized(language)
        }
        //изменения счёта пользователя
        DBUserService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: -Double(lot.currentPrice)) { error in
            if let error = error {
                print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
            } else {
                print("Баланс пользователя успешно обновлен")
            }
        }//обновляет данные лота
        DBLotsService.shared.changeCurentDataLot(LotId: lot.id, currentPrice: lot.currentPrice, currentPerson: lot.currentPerson, idCurrentPerson: idUser, currentEmail: lot.currentEmail)
        //Добавление в наблюдаемые
        if !lot.seePeopleId.contains(idUser) {
            lot.seePeopleId.append(idUser)
        }
        DBLotsService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
    }
    
    func finishLot() {
        textAlert = ""
        //Если есть текущий пользователь, передаём деньги создателю
        if lot.idCurrentPerson != "" {
            DBUserService.shared.updateBalance(for: lot.idCreator, amountToAdd: Double(lot.currentPrice)) { error in
                if let error = error {
                    print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                } else {
                    print("Баланс пользователя успешно обновлен")
                }
            }
            textAlert = "Successfully closed the lot. Your balance is replenished by ".localized(language) +  String(lot.currentPrice) + "$"
        } else {
            //если нет, то просто выводим ошибку
            textAlert = "Successfully closed the lot. Your balance is replenished by 0$".localized(language)
        }
        
        if lot.currentPerson != "None" {
            DBDealsService.shared.addDeal(deal: Deal(id: lot.id,
                                                     buyer: lot.currentPerson,
                                                     salesman: AuthService.shared.currentUser!.email!,
                                                     time: Date(),
                                                     price: lot.currentPrice,
                                                     name: lot.mainText))
        }
        
        DBLotsService.shared.deleteLotPhoto(LotId: lot.id)
        DBLotsService.shared.deleteLotData(LotId: lot.id)
    }
    
    func delLot() {
        textAlert = ""
        //Если есть текущий пользователь, возвразаем ему деньги
        if lot.idCurrentPerson != "" {
            DBUserService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: Double(lot.currentPrice)) { error in
                if let error = error {
                    print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                } else {
                    print("Баланс пользователя успешно обновлен")
                }
            }
            textAlert = "Lot removed. Money returned to:\n".localized(language) +  String(lot.currentPerson) + "\n" + String(lot.currentEmail)
        } else {
            //если нет - просто удаляем
            textAlert = "Lot removed.".localized(language)
        }
        DBLotsService.shared.deleteLotPhoto(LotId: lot.id)
        DBLotsService.shared.deleteLotData(LotId: lot.id)
        
    }
    
    func makeAlert() {
        if lot.idCurrentPerson == idUser {
            if profilView.profile.balance >= plusPrice{
                textDialog = String(self.plusPrice) + "$ will be deducted from your balance. Make an offer?".localized(language)
                variationdialog = "AddPrice"
                showDialog.toggle()
            } else {
                textAlert = "Not Enough money on balance".localized(language)
                showAletr.toggle()
            }
        } else {
            if profilView.profile.balance >= lot.currentPrice + plusPrice{
                textDialog = String(self.plusPrice + lot.currentPrice) + "$ will be deducted from your balance. Make an offer?".localized(language)
                variationdialog = "AddPrice"
                showDialog.toggle()
            } else {
                textAlert = "Not Enough money on balance".localized(language)
                showAletr.toggle()
            }
        }
    }
    
    
    func makeDialog() {
        switch variationdialog {
        case "AddPrice":
            addPrice()
            plusPrice = 500
        case "finish":
            finishLot()
        case "delete":
            delLot()
        default:
            print("error")
        }
        profilView.getProfile()
        showAletr.toggle()
    }
    
    func conf_finish_lot() {
        if lot.idCurrentPerson != "" {
            textDialog = "Do you want to end the auction? Your balance will be replenished by ".localized(language) +  String(lot.currentPrice) + "$"
        } else {
            textDialog = "Do you want to end the auction? Your Balance does Not Change.".localized(language)
        }
        variationdialog = "finish"
        showDialog.toggle()
    }
    
    func conf_del_lot() {
        textDialog = "Do you want to delete the lot? Your account will not change, the money will be returned to the participant".localized(language)
        variationdialog = "delete"
        showDialog.toggle()
    }
    
}
