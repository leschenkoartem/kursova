//
//  FullInfoLotView.swift
//  kursova
//
//  Created by Artem Leschenko on 04.03.2023.
//

import SwiftUI

struct FullInfoLotView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    //Общая инфа
    @EnvironmentObject var profilView:AccountViewModel
    @EnvironmentObject var lotView:LotViewModel
    @Environment(\.dismiss) var dismiss
    
    var lotVM: SmallLotViewModel

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        VStack{
            
            Spacer().frame(height: 15)
            
            ZStack {
                Text(lotVM.lot.mainText).font(.title)
                    .fontWeight(.bold)
                    .opacity(0.7)
                .foregroundColor(Color(.label))
                
                HStack{
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark").font(.title)
                            .fontWeight(.bold)
                            .opacity(0.7)
                        .foregroundColor(Color(.label))
                    }
                    Spacer().frame(width: 15)
                }
            }.padding(.bottom, -1)
            
            Divider().padding(.horizontal, 10)
            
            AsyncImage(url: URL(string: lotVM.lot.image)) { Image in
                Image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 10, height: 350)
                    .cornerRadius(5)
            } placeholder: {
                ProgressView().frame(width: UIScreen.main.bounds.width - 10, height: 350)
                    .cornerRadius(5)
            }
      
            Divider().padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack{
                    Text("Current Price: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(lotVM.lot.currentPrice)$").opacity(0.6)
                }
                
                HStack{
                    Text("Current User: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(lotVM.lot.currentPerson)").opacity(0.6)
                }
                
                HStack{
                    Text("Observed by: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text( String(lotVM.lot.seePeopleId.count) + " user/s".localized(language)).opacity(0.6)
                }
                
                    VStack(alignment: .leading){
                        Text("Lot ID:".localized(language)).opacity(0.6)
                            .fontWeight(.bold)
                        HStack{
                            Text("\(lotVM.lot.id)").opacity(0.6).font(.subheadline)
                            
                            Button {
                                UIPasteboard.general.string = lotVM.lot.id
                            } label: {
                                Image(systemName: "doc.on.doc.fill")
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                
                VStack(alignment: .leading){
                    Text("Creator ID:".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(lotVM.lot.idCreator)").opacity(0.6).font(.subheadline)
                }
                  
                VStack(alignment: .leading){
                    Text("Made Time:".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(dateFormatter.string(from: lotVM.lot.date))").opacity(0.6).font(.subheadline)
                }
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
              
            Spacer()
        }
        
    }
}

struct FullInfoLotView_Previews: PreviewProvider {
    static var previews: some View {
        FullInfoLotView(lotVM: SmallLotViewModel(lot: LotStruct(idCreator: "dcwd", idCurrentPerson: "wdcwc", mainText: "wdc", currentPrice: 2341, informationText: "wdc", date: Date(), seePeopleId: [], image: "wqxw"), profilView: AccountViewModel()))
    }
}
