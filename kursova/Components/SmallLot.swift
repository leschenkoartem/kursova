//
//  SmallLotView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 22.02.2023.
//

import SwiftUI

struct SmallLot: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @ObservedObject var vm: SmallLotViewModel
    
    //для анимации
    @State var selfHeight = 150
    //Для доп информации
    @State var showBigImage = false
    @State var getBigger = false
    
    //Для конекта с текущим юзером
    @EnvironmentObject var profilView : AccountViewModel
    @EnvironmentObject var lotView : LotViewModel
    @Environment(\.dismiss) var dismiss
    
    var idUser = AuthService.shared.currentUser!.uid
    
    var simId:Bool {
        get {
            return vm.lot.idCreator == idUser
        }
    }
    
    var body: some View {
        
        VStack {
            
            //Основной контект маленького экрана
            HStack(alignment: .top) {
                
                AsyncImage(url: URL(string: vm.lot.image)) { Image in
                    Image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }.frame(width: 120, height: 120)
                    .cornerRadius(12)
                    .padding()
                    .clipShape(Rectangle())
                    .padding(.horizontal, -5)
                
                // Текстовая информация о лоте
                VStack(alignment: .leading) {
                    
                    HStack {
                        //Кнопка показываеться только для учасника
                        if vm.lot.idCreator != idUser {
                            //если участника нет в списке наблюдателей
                            if !vm.lot.seePeopleId.contains(idUser) {
                                Button {
                                    //добавляем его в список
                                    vm.addToObserve()
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
                                    vm.dellFromObserve()
                                    lotView.getLots()
                                } label: {
                                    Image(systemName: "eye")
                                }.fontWeight(.bold)
                            }
                        }
                        
                        Text(vm.lot.mainText+"\(simId ? "(Yours)".localized(language) : " ")").font(.title2)
                            .fontWeight(.bold)
                            .opacity(0.7)
                            .foregroundColor(simId ? .yellow : Color(.label))
                        
                    }
                    //Поля с инфой лота
                    HStack(spacing:0) {
                        Text("Current Price: ".localized(language)).opacity(0.6)
                            .padding(.bottom, 2)
                            .fontWeight(.bold)
                        Text("\(vm.lot.currentPrice)$").opacity(0.6)
                            .padding(.bottom, 2)
                    }
                    
                    Text("Current User: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(vm.lot.currentPerson)").opacity(0.7)
                        .foregroundColor(vm.lot.idCurrentPerson == idUser ? .green: Color(.label))
                        .fontWeight(vm.lot.idCurrentPerson == idUser ? .bold: .regular)
                    Text("(\(vm.lot.currentEmail))").opacity(0.7)
                        .foregroundColor(vm.lot.idCurrentPerson == idUser ? .green: Color(.label))
                        .fontWeight(vm.lot.idCurrentPerson == idUser ? .bold: .regular)
                    
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
                    Text("\(vm.lot.informationText)").opacity(0.6).padding(.horizontal, 5)
                        .padding(.top, -10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                if idUser != vm.lot.idCreator{
                    //кнопки
                    HStack {
                        //Кнопка минус
                        Button {
                            vm.plusPrice -= 500
                        } label: {
                            Image(systemName: "minus")
                                .padding()
                        }
                        //Основная кнопка, которая вызывает Диалог с подтверждение сделки
                        Button {
                            vm.makeAlert()
                        } label: {
                            Text("make an offer + ".localized(language) + String(vm.plusPrice) +  "$").padding(8)
                                .fontWeight(.bold)
                                .frame(width: 230)
                                .background(.blue)
                                .foregroundColor(Color(.white))
                                .cornerRadius(5)
                        }
                        //Кнопка плюс
                        Button {
                            vm.plusPrice += 500
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
                            vm.conf_finish_lot()
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
                            vm.conf_del_lot()
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
                FullInfoLotView(lotVM: vm)
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
            .alert(vm.textAlert, isPresented: $vm.showAletr){
                Text("OK")
            }
        //Диалог подтверждения
            .confirmationDialog(vm.textDialog, isPresented: $vm.showDialog, titleVisibility: .visible) {
                //Кнопка нет
                Button(role: .cancel) {
                    vm.showDialog.toggle()
                } label: {
                    Text("No".localized(language))
                }
                //Кнопка да
                Button(role: .destructive) {
                    //Варианты диалога
                    vm.makeDialog()
                    lotView.getLots()
                } label: {
                    Text("Yeah".localized(language))
                }
            }
    }
}

struct SmallLot_Previews: PreviewProvider {
    static var previews: some View {
        SmallLot(vm: SmallLotViewModel(lot: LotStruct(id: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", idCreator: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", idCurrentPerson: "4HW1ZWlnbCPbKCTVjbFOZcqL1fp1", mainText: "kjn", currentPrice: 20000, currentPerson: "Artem Leschenko", currentEmail: "artemleschenko296@gmail.com", informationText: "noneakjfnaefjkdvnqa rfq e qerf  eqr qer f q e rf qr fq e f", date: Date(), seePeopleId: [], image: ""), profilView: AccountViewModel()),
                 idUser: "4HW1ZWlnbCPbKCTVjbFOcqL1fp1").environmentObject(AccountViewModel()).environmentObject(LotViewModel())
    }
}
