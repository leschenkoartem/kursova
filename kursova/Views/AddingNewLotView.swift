//
//  AddingNewLotView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 23.02.2023.
//

import SwiftUI

struct AddingNewLotView: View {
    
    //Для выбора картинки
    
    @State var showSheet = false
    @State var image:UIImage?
    
    //для текстовой информации
    @State var mainText:String = ""
    @State var price:String = ""
    @State var informationText:String = ""
    
    //для вывода ошибки
    @State var showAlert = false
    
    //Для диалога
    @State var showDialog = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotView:LotViewModel
    var body: some View {
        VStack {
            
            //Верхняя часть с картиной и кнопкой назад
            ZStack{
                
                //Если картинка не выбрана
                VStack {
                    Spacer().frame(height: 20)
                    Image(systemName: "plus.circle").resizable().aspectRatio(contentMode: .fill).foregroundColor(Color(.secondaryLabel).opacity(0.75))
                    Text("Add photo +".localaized()).frame(width: 200)
                        .foregroundColor(Color(.secondaryLabel).opacity(0.75))
                        .fontWeight(.bold)
                        .font(.title2)
                }.frame(maxWidth: 150, maxHeight: 150)
                
                //Картинка
                if let image = image{
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: .infinity, height: 300)
                }
                
                    
                                    
                
                //Кнопка наззад
                VStack(alignment: .leading){
                    Spacer().frame(height: 60)
                    HStack(alignment: .top) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                            Text("Сlose".localaized())
                            Spacer().frame(width: 7)
                        }.padding(7)
                            .background()
                            .cornerRadius(.infinity)
                            .padding(.leading, 10)
                            .foregroundColor(Color(.label).opacity(0.75)).fontWeight(.bold)
                            .shadow(radius: 5)
                        
                        Spacer()
                    }
                    Spacer()
                }.frame(maxWidth: .infinity)
                    .frame(height: 300)
                    
            }//при нажатии срабатывает выбор картинки
            .onTapGesture {showSheet.toggle()}
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color(.label).opacity(0.5))
                .cornerRadius(12)
            
            
            
            //Поля для ввода инфы
            VStack {
                CustomTextField(text: $mainText, titlet: "Title".localaized(), texft: "Enter lot`s title".localaized(), maxLettes: 35).padding(.bottom, 15)
                
                //Текст для цены
                VStack(alignment: .leading){
                    
                    Text("Price".localaized()).font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
                    
                    HStack{
                        TextField("Enter lot`s price".localaized(), text: $price)
                            .onChange(of: price) { newValue in
                            if newValue.first == "0"{
                                price = ""
                            }
                        }
                        
                    }
                    
                    Divider()
                }.keyboardType(.numberPad)
                    .padding(.bottom, 15)
                    
                
                //Большой текст
                VStack(alignment: .leading){
                    Text("Information (180lt Max)".localaized()).font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
                    ZStack {
                        
                        
                        TextEditor(text: $informationText)
                            .foregroundColor(Color(.label))
                            .frame(maxHeight: 100)
                            .cornerRadius(8)
                            .onChange(of: informationText) { newText in
                            if newText.count > 180 { // Limit input to 180 characters
                                informationText = String(newText.prefix(180))
                            }
                        }
                        
                        Text("Enter text here...".localaized())
                            .foregroundColor(Color(.label).opacity(0.2))
                            .opacity(informationText.isEmpty ? 1 : 0) // Show the background text when the text is empty

                    }
                    
                    Divider()
                }
                
                
                //Кнопка регистрации лота
                Button {
                    if mainText == "" || price == "" || informationText == "" || image == nil {
                        showAlert.toggle()
                    }else{
                        showDialog.toggle()
                    }
                }label: {
                    Text("Add".localaized()).foregroundColor(Color(.label).opacity(0.75)).frame(width: 120).padding()
                    
                }.background(Color(.systemGray5))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                    .shadow(radius: 5)
                
                
                
                
                Spacer()
            }.padding()
            
        }
        .edgesIgnoringSafeArea(.top)
        //Лист с выбором картинок
        .sheet(isPresented: $showSheet) {
            ImagePicker(selectedImage: $image)
        }
        //Ошибка
        .alert("Not Enough Data".localaized(), isPresented: $showAlert){
            Text("OK")
        }
        //Диалог подтверждения
        .confirmationDialog("Do you confirm the creation of the lot?".localaized(), isPresented: $showDialog, titleVisibility: .visible) {
            //Кнопка нет
            Button(role: .cancel) {
                showDialog.toggle()
            } label: {
                Text("No".localaized())
            }
            //Кнопка да
            Button(role: .destructive) {
                print("Okay".localaized())
                
                //Создаём лот
                let lotcreat = LotStruct(idCreator: AuthService.shared.currentUser!.uid, idCurrentPerson: "", mainText: mainText + " ", currentPrice: Int(price)!, informationText: informationText, date: Date(), seePeopleId: [], image: "")
                
                //Передаём его в бд
                DatabaseService.shared.addLotToFirestore(lot: lotcreat)
                
                //передаём картинку в бд
                DatabaseService.shared.uploadLotImage(image: image ?? UIImage(imageLiteralResourceName: "1"), LotId: lotcreat.id)
                
                
                //Lаэм время бд загрузить картинку, а потом достаём её юрл
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    //достаём ЮРЛ картинки
                    DatabaseService.shared.getImageUrl(imagePath: lotcreat.id, path: "lots_loogo") { url in
                        if let url = url{
                            DatabaseService.shared.updateLotPhotoUrl(LotId: lotcreat.id, newPhotoUrl: url.absoluteString)
                            lotView.getLots()
                            dismiss()
                        }else{
                            print("fail")
                        }
                    }
                }
                
                
                
                
                        
            }label: {
                Text("Yeah".localaized())
            }
        }
        //Для клавиатуры
        .onTapGesture {
            UIApplication.shared.endEditing()
        }

    }
}

struct AddingNewLotView_Previews: PreviewProvider {
    static var previews: some View {
        AddingNewLotView()
    }
}
