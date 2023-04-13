//
//  Accountview.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 21.02.2023.
//
import SwiftUI

struct HomeView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var creatLot = false
    @State var showSheet = false
    @State private var image: UIImage?
    @State var isConfirm = false
    @State var showLots = 1
    
    @EnvironmentObject var profileView: AccountViewModel
    @EnvironmentObject var lotView: LotViewModel
    
    var body: some View {
        
        VStack{
            //Панелька с инфой юзера
            ZStack{
                HStack(spacing: 15){
                    
                    if profileView.profile.image == ""{
                        Image(systemName: "plus").resizable()
                            .foregroundColor(Color(.label).opacity(0.6))
                            .frame(width: 40, height: 40)
                            .frame(width: 60, height: 60)
                            .background(Color(.label).opacity(0.1))
                            .clipShape(Circle())
                            .onTapGesture {showSheet.toggle()}
                    }else{
                        AsyncImage(url: URL(string: profileView.profile.image)) { Image in
                            
                            Image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                                .background(Color.black.opacity(0.1))
                                .clipShape(Circle())
                        }.onTapGesture { showSheet.toggle() }
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    
                    Divider()
                    
                    VStack(alignment: .leading){
                        Text(profileView.profile.name).foregroundColor(Color(.label).opacity(0.75))
                        Text(profileView.profile.email).foregroundColor(Color(.label).opacity(0.4))
                        Text("\(profileView.profile.balance)$").foregroundColor(Color(.label).opacity(0.4))
                        
                    }
                    Spacer()
                    //Конпка выхода
                    Button {
                        isConfirm.toggle()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.custom("", size: 20))
                            .foregroundColor(Color(.label).opacity(0.7))
                    }
                    
                }.padding(20)
                
            }.frame(maxWidth: .infinity, maxHeight: 100,  alignment: .topLeading)
                .background(Color(.systemGray5).opacity(0.75))
                .cornerRadius(30)
                .padding(.horizontal, 5)
                .shadow(radius: 5)
            
            //Выбор своих или чужих лотов
            Picker("", selection: $showLots) {
                Text("Self Lots".localized(language)).tag(1)
                Text("Active Offers".localized(language)).tag(2)
                Text("Marked lots".localized(language)).tag(3)
            }.pickerStyle(SegmentedPickerStyle())
                .padding(5)
            
            //Скролы с лотами
            if showLots == 1{
                Text("Your Lots:".localized(language)).foregroundColor(Color(.label).opacity(0.75))
                    .font(.title).fontWeight(.bold)
                Text("Lots, That You Made.".localized(language)).foregroundColor(Color(.systemGray3).opacity(0.75))
                Divider()
                Button {
                    creatLot.toggle()
                } label: {
                    Text("Add new lot +".localized(language)).foregroundColor(Color(.label).opacity(0.65)).fontWeight(.bold)
                }
                
                ScrollView{
                    Spacer().frame(height: 10)
                    LazyVStack {
                        ForEach(0..<lotView.lotsList.count, id: \.self){item in
                            if let user = AuthService.shared.currentUser?.uid{
                                let lot = lotView.lotsList[item]
                                if lot.idCreator == user{
                                    SmallLot(selfViewModel: SmallLotViewModel(lot: lot))
                                }
                            }
                        }
                        Spacer().frame(height: 130)
                        
                    }.refreshable {
                        lotView.getLots()
                    }
                }
            }else if showLots == 2{
                Text("Active Offers:".localized(language)).foregroundColor(Color(.label).opacity(0.75))
                    .font(.title).fontWeight(.bold)
                Text("Lots, in Which You Participate".localized(language)).foregroundColor(Color(.systemGray3).opacity(0.75))
                Divider()
                
                ScrollView{
                    Spacer().frame(height: 10)
                    LazyVStack {
                        ForEach(0..<lotView.lotsList.count, id: \.self) {item in
                            if let user = AuthService.shared.currentUser?.uid{
                                let lot = lotView.lotsList[item]
                                if lot.idCurrentPerson == user{
                                    SmallLot(selfViewModel: SmallLotViewModel(lot: lot))
                                }
                            }
                        }
                        Spacer().frame(height: 130)
                    }.refreshable {
                        lotView.getLots()
                    }
                }
                Spacer()
                
            }else{
                Text("Marked Lots:".localized(language)).foregroundColor(Color(.label).opacity(0.75))
                    .font(.title).fontWeight(.bold)
                Text("Lots You Marked".localized(language)).foregroundColor(Color(.systemGray3).opacity(0.75))
                Divider()
                
                ScrollView{
                    Spacer().frame(height: 10)
                    LazyVStack{
                        ForEach(0..<lotView.lotsList.count, id: \.self){item in
                            if let user = AuthService.shared.currentUser?.uid{
                                let lot = lotView.lotsList[item]
                                if lot.seePeopleId.contains(user){
                                    SmallLot(selfViewModel: SmallLotViewModel(lot: lot))
                                }
                            }
                        }
                        Spacer().frame(height: 130)
                    }.refreshable {
                        lotView.getLots()
                    }
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.bottom)
        //Подтверждение выхода
            .confirmationDialog("Are You sure you want to Log Out?".localized(language), isPresented: $isConfirm, titleVisibility: .visible) {
                Button(role: .cancel) {
                    isConfirm.toggle()
                } label: {
                    Text("No".localized(language))
                }
                Button(role: .destructive) {
                    AuthService.shared.signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                } label: {
                    Text("Yeah".localized(language))
                }
                
            }//При показе экрана запрашываются даные из базы данных
            .onAppear{
                profileView.getProfile()
                lotView.getLots()
            }
            .sheet(isPresented: $showSheet, onDismiss: {
                if let image = image {
                    //Добавляем картинку в бд
                    DBUserService.shared.uploadUserImage(image: image)
                    //Получаем ЮРЛ из бд
                    Task {
                        do {
                            let url = try await DBUserService.shared.getImageUrl(imagePath: AuthService.shared.currentUser!.uid, path: "users_logo")
                            DBUserService.shared.updateUserPhotoUrl(userId: AuthService.shared.currentUser!.uid, newPhotoUrl: url.absoluteString)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                profileView.getProfile()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }) {
                ImagePicker(selectedImage: $image)
            }
            .fullScreenCover(isPresented: $creatLot) {
                AddingNewLotView()
            }
    }
}
    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(LotViewModel()).environmentObject(AccountViewModel())
    }
}
