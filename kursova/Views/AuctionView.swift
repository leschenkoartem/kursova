//
//  AuctionsView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI

struct AuctionsView: View {
    
    
    @State var searchWord = ""
    @EnvironmentObject var lotView: LotViewModel
    
    var searchStringWord:String{
        get{
            if searchWord == ""{
                return " "
            }else{
                return searchWord
            }
        }
    }
    

    var body: some View {
        VStack{
            
            HStack{
                if searchWord == ""{
                    Image(systemName: "magnifyingglass").foregroundColor(Color(.label).opacity(0.5))
                    
                }else{
                    Button {
                        searchWord.removeAll()
                    } label: {
                        Image(systemName: "xmark").foregroundColor(Color(.label).opacity(0.5))
                    }

                }
                
                TextField("Search by keyword...", text: $searchWord).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                    .foregroundColor(Color(.label).opacity(0.5))
            }.padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.top, 10)
                .padding(.horizontal, 10)
            
            ScrollView{
                ForEach(0..<lotView.lots_info.count, id: \.self){item in
                    if lotView.lots_info[item].mainText.uppercased().contains(searchStringWord.uppercased()){
                        SmallLot(lot: lotView.lots_info[item], idUser:  AuthService.shared.currentUser!.uid)
                    }
                }
                Spacer().frame(height: 130)
                
            }
            
            Spacer()
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear{
                lotView.getLots()
                
                print(lotView.lots_info.count)
            }
        .onTapGesture {
                    UIApplication.shared.endEditing()
                }
    }
}

struct AuctionsView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionsView().environmentObject(LotViewModel())
    }
}
