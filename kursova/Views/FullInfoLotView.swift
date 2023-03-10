//
//  FullInfoLotView.swift
//  kursova
//
//  Created by Artem Leschenko on 04.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullInfoLotView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    //Общая инфа
    @EnvironmentObject var profilView:AccountViewModel
    @EnvironmentObject var lotView:LotViewModel
    @Environment(\.dismiss) var dismiss
    
    var title:String
    var currentUser:String
    var LotID:String
    var currentPrice:Int
    var CreatorID:String
    var date:Date
    var count:Int
    var image:String
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        VStack{
            
            Spacer().frame(height: 15)
            
            ZStack {
                Text(title).font(.title)
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
            
            WebImage(url: URL(string: image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                
                .frame(width: UIScreen.main.bounds.width - 10, height: 350)
                
                .cornerRadius(5)
                
                
            Divider().padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 8){
                HStack{
                    Text("Current Price: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(currentPrice)$").opacity(0.6)
                }
                HStack{
                    Text("Current User: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(currentUser)").opacity(0.6)
                }
                
                HStack{
                    Text("Observed by: ".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text( String(count) + " user/s".localized(language)).opacity(0.6)
                }
                
                VStack(alignment: .leading){
                    Text("Lot ID:".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(LotID)").opacity(0.6).font(.subheadline)
                }
                
                VStack(alignment: .leading){
                    Text("Creator ID:".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(CreatorID)").opacity(0.6).font(.subheadline)
                }
                  
                VStack(alignment: .leading){
                    Text("Made Time:".localized(language)).opacity(0.6)
                        .fontWeight(.bold)
                    Text("\(dateFormatter.string(from: date))").opacity(0.6).font(.subheadline)
                }
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            
            
            
            Spacer()
        }
        
    }
}

struct FullInfoLotView_Previews: PreviewProvider {
    static var previews: some View {
        FullInfoLotView(title: "Main Title", currentUser: "Artem Leschenko",  LotID: "2138D424-E0B2-430B-A8A6-D9EF6569212D", currentPrice: 20000, CreatorID: "2138D424-E0B2-430B-A8A6-D9EF6569212D", date: Date(), count: 32, image: "k" )
    }
}
