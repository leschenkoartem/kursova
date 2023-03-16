//
//  SmallLotView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 22.02.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SmallLot: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    var selfViewModel : SmallLotViewModel
    
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
    @EnvironmentObject var profilView : AccountViewModel
    @EnvironmentObject var lotView : LotViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var plusPrice = 500 {
        didSet {
            if plusPrice < 500{
                plusPrice = 500
            }
        }
    }
    @State var getBigger = false
    
    var idUser: String
    
    var simId:Bool {
        get {
            return selfViewModel.lot.idCreator == idUser
        }
    }
    
    var body: some View {
        
        VStack {
            
            //Основной контект маленького экрана
            HStack(alignment: .top) {
                
                WebImage(url: URL(string: selfViewModel.lot.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .cornerRadius(12)
                    .padding()
                    .clipShape(Rectangle())
                    .padding(.horizontal, -5)
                
                // Текстовая информация о лоте
                VStack(alignment: .leading) {
                    
                    HStack {
                        //Кнопка показываеться только для учасника
                        if selfViewModel.lot.idCreator != idUser{
                            
                            //если участника нет в списке наблюдателей
                            if !selfViewModel.lot.seePeopleId.contains(idUser) {
                                Button {
                                    //добавляем его в список
                                    selfViewModel.addToObserve()
                                    lotView.getLots()
                                    
                                } label: {
                                    Image(systemName: "eye.slash")
                                    
                                }.opacity(0.6)
                                    .foregroundColor(Color(.label))
                                    .fontWeight(.bold)
                                
                            } else {
                                //если он есть
                                Button {
                                    //удаляем из списка
                                    selfViewModel.dellFromObserve()
                                    lotView.getLots()
                                    
                                } label: {
                                    Image(systemName: "eye")
                                }.fontWeight(.bold)
                            }
                        }
                        
                        Text(selfViewModel.lot.mainText+"\(simId ? "(Yours)".localized(language) : " ")").font(.title2)
                            .fontWeight(.bold)
                            .opacity(0.7)
                            .foregroundColor(simId ? .yellow : Color(.label))
                        
                    }
                    //Поля с инфой лота
                    HStack(spacing:0) {
                        Text("Current Price: ".localized(language)).opacity(0.6)
                            .padding(.bottom, 2)
                            .fontWeight(.bold)
                        Text("\(selfViewModel.lot.currentPrice)$").opacity(0.6)
                            .padding(.bottom, 2)
                    }
                    
                    Text("Current User: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(selfViewModel.lot.currentPerson)").opacity(0.7)
                        .foregroundColor(selfViewModel.lot.idCurrentPerson == idUser ? .green: Color(.label))
                        .fontWeight(selfViewModel.lot.idCurrentPerson == idUser ? .bold: .regular)
                    Text("(\(selfViewModel.lot.currentEmail))").opacity(0.7)
                        .foregroundColor(selfViewModel.lot.idCurrentPerson == idUser ? .green: Color(.label))
                        .fontWeight(selfViewModel.lot.idCurrentPerson == idUser ? .bold: .regular)
                    
                    Spacer()
                    
                }.padding(.vertical)
                    .frame(maxHeight: 150)
                
                Spacer()
                
            }.padding(.vertical).frame(maxHeight: 150)
            
            //Усли экран увеличивается и лот не принадлежит текущему юзеру - есть кнопка добавления цены
            if getBigger {
                
                VStack {
                    //Информация по лоту
                    Text(" Information:".localized(language)).opacity(0.7).padding(.horizontal, 5).fontWeight(.bold)
                        .padding(.top, -10)
                    Text("\(selfViewModel.lot.informationText)").opacity(0.6).padding(.horizontal, 5)
                        .padding(.top, -10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                if idUser != selfViewModel.lot.idCreator{
                    //кнопки
                    HStack {
                        //Кнопка минус
                        Button {
                            plusPrice-=500
                        } label: {
                            Image(systemName: "minus")
                                .padding()
                        }
                        //Основная кнопка, которая вызывает Диалог с подтверждение сделки
                        Button {
                            if selfViewModel.lot.idCurrentPerson == idUser{
                                if profilView.profile.balance >= plusPrice{
                                    textDialog = String(self.plusPrice) + "$ will be deducted from your balance. Make an offer?".localized(language)
                                    variationdialog = 1
                                    showDialog.toggle()
                                }else{
                                    textAlert = "Not Enough money on balance".localized(language)
                                    showAletr.toggle()
                                }
                            }else{
                                if profilView.profile.balance >= selfViewModel.lot.currentPrice + plusPrice{
                                    textDialog = String(self.plusPrice + selfViewModel.lot.currentPrice) + "$ will be deducted from your balance. Make an offer?".localized(language)
                                    variationdialog = 1
                                    showDialog.toggle()
                                }else{
                                    textAlert = "Not Enough money on balance".localized(language)
                                    showAletr.toggle()
                                }
                            }
                        } label: {
                            Text("make an offer + ".localized(language) + String(self.plusPrice) +  "$").padding(8)
                                .fontWeight(.bold)
                                .frame(width: 230)
                                .background(.blue)
                                .foregroundColor(Color(.white))
                                .cornerRadius(5)
                        }
                        //Кнопка плюс
                        Button {
                            plusPrice+=500
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                        }
                    }.padding(5)
                        .padding(.bottom, 5)
                        .opacity(getBigger ? 1 : 0)
                }else{
                    HStack{
                        //Основная кнопка, которая вызывает Диалог с подтверждением завершения аукциона
                        Button {
                            if selfViewModel.lot.idCurrentPerson != "" {
                                textDialog = "Do you want to end the auction? Your balance will be replenished by ".localized(language) +  String(selfViewModel.lot.currentPrice) + "$"
                            } else {
                                textDialog = "Do you want to end the auction? Your Balance does Not Change.".localized(language)
                            }
                            variationdialog = 2
                            showDialog.toggle()
                        } label: {
                            Text("Finish".localized(language)).padding(8)
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
                            textDialog = "Do you want to delete the lot? Your account will not change, the money will be returned to the participant".localized(language)
                            variationdialog = 3
                            showDialog.toggle()
                        } label: {
                            Text("Delete".localized(language)).padding(8)
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
            }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: CGFloat(selfHeight))
            .background(Color(.systemGray6).opacity(0.75))
            .padding(.horizontal, 5)
            .cornerRadius(30)
            .shadow(radius: 5)
        //Делаем анимацию
            .animation(.easeInOut(duration: 0.5), value: getBigger)
        
        //Полная инфа(ЛИСТ)
            .sheet(isPresented: $showBigImage){
                FullInfoLotView(lot: selfViewModel)
            }
        //"Если будет нажато" то происходит изменение высоты с анимацией(БЫСТРОЕ НАЖАТИЕ)
            .onTapGesture {
                getBigger.toggle()
                withAnimation {
                    selfHeight = selfHeight == 150 ? 350:150
                }
            }
        //"Если будет нажато" то открывается полная инфа (МЕДЛЕННОЕ НАЖАТИЕ)
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
                    Text("No".localized(language))
                }
                //Кнопка да
                Button(role: .destructive) {
                    //Варианты диалога
                    switch variationdialog{
                        //Смена цены и пользователя
                    case 1:
                        textAlert = selfViewModel.addPrice(idUser: idUser,
                                                           plusPrice: plusPrice,
                                                           name: profilView.profile.name,
                                                           email: profilView.profile.email)
                        plusPrice = 500
                    case 2:
                        
                        textAlert = selfViewModel.finishLot(idUser: idUser,
                                                            plusPrice: plusPrice,
                                                            name: profilView.profile.name,
                                                            email: profilView.profile.email)
                        //Удаление лота
                    case 3:
                        textAlert = selfViewModel.delLot(idUser: idUser,
                                                         plusPrice: plusPrice,
                                                         name: profilView.profile.name,
                                                         email: profilView.profile.email)
                    default:
                        print("error")
                    }
                    profilView.getProfile()
                    lotView.getLots()
                    showAletr.toggle()
                } label: {
                    Text("Yeah".localized(language))
                }
            }
    }
}

struct SmallLot_Previews: PreviewProvider {
    static var previews: some View {
        SmallLot(selfViewModel: SmallLotViewModel(lot: LotStruct(id: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", idCreator: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", idCurrentPerson: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", mainText: "kjn", currentPrice: 20000, currentPerson: "Artem Leschenko", currentEmail: "artemleschenko296@gmail.com", informationText: "noneakjfnaefjkdvnqa rfq e qerf  eqr qer f q e rf qr fq e f", date: Date(), seePeopleId: [], image: "")),
                 idUser: "4HW1ZWlnbCPbKCTVjbFOcqL1fp1").environmentObject(AccountViewModel()).environmentObject(LotViewModel())
    }
}
