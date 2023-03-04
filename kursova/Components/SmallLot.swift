//
//  SmallLotView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 22.02.2023.
//

import SwiftUI


struct SmallLot: View {
    
    
    //для анимации
    @State var selfHeight = 150
    
    //Для ошибки
    @State var showAletr = false
    @State var textAlert = ""
    
    //Для диалога
    @State var showDialog = false
    @State var textDialog = ""
    @State var variationdialog = 1
    
    //Для доп информации
    @State var showBigImage = false
    
    //Для конекта с текущим юзером
    @EnvironmentObject var profilView:AccountViewModel
    @EnvironmentObject var lotView:LotViewModel
    @Environment(\.dismiss) var dismiss
    
    //для конекта с списком лотов
    @State var lot:Lot_str
    @State var plusPrice = 500{
        didSet{
            if plusPrice < 500{
                plusPrice = 500
            }
        }
    }
    @State var getBigger = false
    
    
    
    var idUser: String
    var simId:Bool{
        get{
            if lot.idCreator == idUser{
                return true
            }else{
                return false
            }
        }
    }
    
    
    var body: some View {
        
                VStack{
                    
                    //Основной контект маленького экрана
                    HStack(alignment: .top){
                        
                      
                            Image("1").resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .cornerRadius(12)
                                .padding()
                                .clipShape(Rectangle())
                                .padding(.horizontal, -5)
                            
                        
                        
                                                        
                            
                        // Текстовая информация о лоте
                        VStack(alignment: .leading){
                            
                            
                            
                            
                            
                            
                            
                            HStack {
                                if lot.idCreator != idUser{
                                    
                                    
                                    if !lot.seePeopleId.contains(idUser) {
                                        Button {
                                            if !lot.seePeopleId.contains(idUser) {
                                                lot.seePeopleId.append(idUser)
                                                    }
                                            DatabaseService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
                                            lotView.getLots()
                                            
                                        } label: {
                                            Image(systemName: "eye.slash")
                                            
                                        }.opacity(0.6)
                                            .foregroundColor(Color(.label))
                                            .fontWeight(.bold)
                                    }else{
                                        Button {
                                            if let index = lot.seePeopleId.firstIndex(of: AuthService.shared.currentUser!.uid) {
                                                lot.seePeopleId.remove(at: index)
                                                    }
                                            DatabaseService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
                                            lotView.getLots()
                                            
                                        } label: {
                                            Image(systemName: "eye")
                                            
                                        }.fontWeight(.bold)
                                        
                                        
                                    }
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                Text(lot.mainText+"\(simId ? "(Yours)": " ")").font(.title2)
                                    .fontWeight(.bold)
                                    .opacity(0.7)
                                .foregroundColor(simId ? .yellow : Color(.label))
                            }
                            
                            HStack(spacing:0){
                                Text("Current Price: ").opacity(0.6)
                                    .padding(.bottom, 2)
                                    .fontWeight(.bold)
                                Text("\(lot.currentPrice)$").opacity(0.6)
                                    .padding(.bottom, 2)
                            }
                            
                            
                            Text("Current Person: ").opacity(0.6)
                                .fontWeight(.bold)
                                
                            Text("\(lot.currentPerson)").opacity(0.7)
                                .foregroundColor(lot.idCurrentPerson == idUser ? .green: Color(.label))
                                .fontWeight(lot.idCurrentPerson == idUser ? .bold: .regular)
                            
                            Text("(\(lot.currentEmail))").opacity(0.7)
                                .foregroundColor(lot.idCurrentPerson == idUser ? .green: Color(.label))
                                .fontWeight(lot.idCurrentPerson == idUser ? .bold: .regular)
                                
                            
                            
                            
                            Spacer()
                        }.padding(.vertical)
                            .frame(maxHeight: 150)
                            
                        Spacer()
  
                    }.padding(.vertical).frame(maxHeight: 150)
                        
                    
                    //Усли экран увеличивается и лот не принадлежит текущему юзеру - есть кнопка добавления цены
                    if getBigger && idUser != lot.idCreator{
                        
                        VStack{
                            //Информация по лоту
                            Text("  Information:").opacity(0.7).padding(.horizontal, 5).fontWeight(.bold)
                                .padding(.top, -10)
                            Text("\(lot.informationText)").opacity(0.6).padding(.horizontal, 5)
                                .padding(.top, -10)
                        }
                        
                        Spacer()
                       

                        //кнопки
                        HStack {
                            
                            
                            Button {
                                plusPrice-=500
                            } label: {
                                Image(systemName: "minus")
                                    .padding()
                            }

                            //Основная кнопка, которая вызывает Диалог с подтверждение сделки
                            Button {
                                if profilView.profile.balance >= lot.currentPrice + plusPrice{
                                    textDialog = "\(self.plusPrice + lot.currentPrice)$ will be deducted from your balance. Make an offer?"
                                    variationdialog = 1
                                    showDialog.toggle()
                                }else{
                                    textAlert = "Not Enough money on balance"
                                    showAletr.toggle()
                                }
                                
                            } label: {
                              
                                    Text("make an offer + \(self.plusPrice)$").padding(8)
                                                .fontWeight(.bold)
                                                .frame(width: 230)
                                            .background(.blue)
                                            .foregroundColor(Color(.white))
                                            .cornerRadius(5)
                                            
                            }
                            
                            Button {
                                plusPrice+=500
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                            }
                            
                            
                    }.padding(5)
                            .padding(.bottom, 5)

                    }//Усли экран увеличивается и лот принадлежит текущему юзеру - есть две кнопки
                    else if getBigger && simId{
                        VStack{
                            Text("  Information:").opacity(0.7).padding(.horizontal, 5).fontWeight(.bold)
                                .padding(.top, -10)
                            Text("\(lot.informationText)").opacity(0.6).padding(.horizontal, 5)
                                .padding(.top, -10)
                        }
                        
                        Spacer()
                        
                        
                        HStack{
                            //Основная кнопка, которая вызывает Диалог с подтверждением завершения аукциона
                            Button {
                                if lot.idCurrentPerson != ""{
                                    textDialog = "Do you want to end the auction? Your balance will be replenished by \(lot.currentPrice)$"
                                }else{
                                    textDialog = "Do you want to end the auction? Your Balance does Not Change."
                                }
                                
                                
                                variationdialog = 2
                                showDialog.toggle()
                            } label: {
                                
                                Text("Finish").padding(8)
                                    .fontWeight(.bold)
                                    .frame(width: 150)
                                    .background(.green)
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(5)
                                    .padding(5)
                                    .padding(.bottom, 5)
                            }
                            //Основная кнопка, которая вызывает Диалог с подтверждением удаления аукциона
                            Button {
                                textDialog = "Do you want to delete the lot? Your account will not change, the money will be returned to the participant"
                                variationdialog = 3
                                showDialog.toggle()
                            } label: {
                                
                                Text("Delete").padding(8)
                                    .fontWeight(.bold)
                                    .frame(width: 150)
                                    .background(.red)
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(5)
                                    .padding(5)
                                    .padding(.bottom, 5)
                            }
                        }
                        
                        

                    }
                    
                }.frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: CGFloat(selfHeight))
                    .background(Color(.systemGray6).opacity(0.75))
                    .padding(.horizontal, 5)
                    .cornerRadius(30)
                    .shadow(radius: 5)
                    //Делаем анимацию
                    .animation(.easeInOut(duration: 0.3))
                    
                    //Полная инфа
                    .sheet(isPresented: $showBigImage){
                        FullInfoLotView(title: lot.mainText, currentUser: lot.currentPerson, LotID: lot.id, currentPrice: lot.currentPrice, CreatorID: lot.idCreator, date: lot.date, count: lot.seePeopleId.count)
                        
                    }
        
                    //"Если будет нажато" то происходит изменение высоты с анимацией
                    .onTapGesture {
                        getBigger.toggle()
                        withAnimation {
                            selfHeight = selfHeight == 150 ? 350:150
                                        }
                    }
                    .onLongPressGesture(minimumDuration: 0.2) {
                        showBigImage.toggle()
                                }
        
                    //Ошибка
                    .alert(textAlert, isPresented: $showAletr){
                        Text("OK")
                    }
        
                    //Диалог подтверждения
                    .confirmationDialog(textDialog, isPresented: $showDialog, titleVisibility: .visible) {
                        //Кнопка нет
                        Button(role: .cancel) {
                            showDialog.toggle()
                        } label: {
                            Text("No")
                        }
                        //Кнопка да
                        Button(role: .destructive) {
                            //Варианты диалога
                            switch variationdialog{
                                //Смена цены и пользователя
                            case 1:
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
                                
                                    lot.idCurrentPerson = idUser
                                    lot.currentPrice += plusPrice
                                    lot.currentPerson = profilView.profile.name
                                    lot.currentEmail = profilView.profile.email
                                    
                                DatabaseService.shared.updateBalance(for: lot.idCurrentPerson, amountToAdd: -Double(lot.currentPrice)) { error in
                                        if let error = error {
                                            print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                                            
                                        } else {
                                            print("Баланс пользователя успешно обновлен")
                                            
                                        }
                                }
                                
                                textAlert = "Successful deal. \(lot.currentPrice)$ deducted from your balance"
                                plusPrice = 500
                                showAletr.toggle()
                                profilView.getProfile()
                                
                                //обновляет данные лота
                                DatabaseService.shared.changeCurentDataLot(LotId: lot.id, currentPrice: lot.currentPrice, currentPerson: lot.currentPerson, idCurrentPerson: idUser, currentEmail: lot.currentEmail)
                                
                                //Добавление в наблюдаемые
                                if !lot.seePeopleId.contains(idUser) {
                                    lot.seePeopleId.append(idUser)
                                        }
                                DatabaseService.shared.delPeoplSee(LotId: lot.id, arrayID: lot.seePeopleId)
                                lotView.getLots()
                                //Финиш лота
                            case 2:
                                
                                if lot.idCurrentPerson != ""{
                                    DatabaseService.shared.updateBalance(for: lot.idCreator, amountToAdd: Double(lot.currentPrice)) { error in
                                        if let error = error {
                                            print("Ошибка при обновлении баланса пользователя: \(error.localizedDescription)")
                                            
                                        } else {
                                            print("Баланс пользователя успешно обновлен")
                                            
                                        }
                                    }
                                    profilView.getProfile()
                                    textAlert = "Successfully closed the lot. Your balance is replenished by \(lot.currentPrice)$"
                                    showAletr.toggle()
                                }else{
                                    textAlert = "Successfully closed the lot. Your balance is replenished by 0$"
                                    showAletr.toggle()
                                }
                                
                                
                                
                                
                                //Удаление лота
                            case 3:
                                
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
                                    textAlert = "Lot removed."
                                    
                                }

                                showAletr.toggle()
                                DatabaseService.shared.deleteLotData(LotId: lot.id)
                                lotView.getLots()
                                
                                
                            default:
                                print("xdx")
                            }
                        } label: {
                            Text("Yeah")
                        }
                        
                    }
    }
}

struct SmallLot_Previews: PreviewProvider {
    static var previews: some View {
        SmallLot(lot: Lot_str(id: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", idCreator: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", idCurrentPerson: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", mainText: "kjn", currentPrice: 20000, currentPerson: "Artem Leschenko", currentEmail: "artemleschenko296@gmail.com", informationText: "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo", date: Date(), seePeopleId: []),
                 idUser: "4HW1ZWlnbCPbKCTVjbFOcqL1fp1").environmentObject(AccountViewModel()).environmentObject(LotViewModel())
    }
}
