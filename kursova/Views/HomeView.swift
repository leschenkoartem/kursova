//
//  Accountview.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 21.02.2023.
//
import SwiftUI

struct HomeView: View {
    
    @State var creatLot = false
    @State var showSheet = false
    @State private var image = UIImage()
    @Binding var isUserLogin:Bool
    @State var isConfirm = false
    @State var showLots = 1
    
    @EnvironmentObject var profileView:AccountViewModel
    @EnvironmentObject var lotView: LotViewModel
    
    var body: some View {
        
        VStack{
            //Панелька с инфой юзера
            ZStack{
                HStack(spacing: 15){
                    Image(uiImage: self.image)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .background(Color.black.opacity(0.7))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .onTapGesture {showSheet.toggle()}
                    
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
                Text("Self Lots").tag(1)
                Text("Active Offers").tag(2)
                Text("Marked lots").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
                .padding(5)
            
            //Скролы с лотами
            if showLots == 1{
                Text("Your Lots:").foregroundColor(Color(.label).opacity(0.75))
                    .font(.title).fontWeight(.bold)
                Text("Lots, That You Made.").foregroundColor(Color(.systemGray3).opacity(0.75))
                Divider()
                Button {
                    creatLot.toggle()
                } label: {
                    Text("Add new lot +").foregroundColor(Color(.systemGray).opacity(0.75)).fontWeight(.bold)
                }
                ScrollView{
                    Spacer().frame(height: 10)
                    ForEach(0..<lotView.lots_info.count, id: \.self){item in
                        if let user = AuthService.shared.currentUser?.uid{
                            let lot = lotView.lots_info[item]
                            if lot.idCreator == user{
                                SmallLot(lot: lot, idUser:  AuthService.shared.currentUser!.uid)
                            }
                        }
                    }
                    Spacer().frame(height: 130)
                    
                }
            }else if showLots == 2{
                Text("Active Offers:").foregroundColor(Color(.label).opacity(0.75))
                    .font(.title).fontWeight(.bold)
                Text("Lots, in Which You Participate").foregroundColor(Color(.systemGray3).opacity(0.75))
                Divider()
                
                
                ScrollView{
                    Spacer().frame(height: 10)
                    ForEach(0..<lotView.lots_info.count, id: \.self) {item in
                        if let user = AuthService.shared.currentUser?.uid{
                            let lot = lotView.lots_info[item]
                            if lot.idCurrentPerson == user{
                                
                                SmallLot(lot: lot, idUser:  AuthService.shared.currentUser!.uid)
                            }
                        }
                    }
                    Spacer().frame(height: 130)
                }
                
                
                
                
                Spacer()
                
            }else{
                Text("Marked Lots:").foregroundColor(Color(.label).opacity(0.75))
                    .font(.title).fontWeight(.bold)
                Text("Lots You Marked").foregroundColor(Color(.systemGray3).opacity(0.75))
                Divider()
                
                
                Spacer()
            }
            
            
            
            
            
            
        }.edgesIgnoringSafeArea(.bottom)
            //Подтверждение выхода
                .confirmationDialog("Are You sure you want to Log Out?", isPresented: $isConfirm, titleVisibility: .visible) {
                    
                    Button(role: .cancel) {
                        isConfirm.toggle()
                    } label: {
                        Text("No")
                    }
                    Button(role: .destructive) {
                        AuthService.shared.signOut()
                        isUserLogin.toggle()
                    } label: {
                        Text("Yeah")
                    }
                    
                }//При показе экрана запрашываются даные из базы данных
                .onAppear{
                    if AuthService.shared.currentUser != nil{
                        self.profileView.getProfile()
                    }
                }
                .sheet(isPresented: $showSheet) {
                    ImagePicker(selectedImage: $image)
                }
                .fullScreenCover(isPresented: $creatLot) {
                    AddingNewLotView()
                }
    }
}
    
struct HomeView_Previews: PreviewProvider {
    @State static var a:Bool = false
    static var previews: some View {
        HomeView( isUserLogin: $a).environmentObject(LotViewModel()).environmentObject(AccountViewModel())
    }
}
