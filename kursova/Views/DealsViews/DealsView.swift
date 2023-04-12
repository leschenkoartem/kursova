//
//  DealsView.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import SwiftUI

struct DealsView: View {
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject var dealsView = DealsViewModel()
    @State var text = ""
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    if text == ""{
                        Image(systemName: "magnifyingglass").foregroundColor(Color(.label).opacity(0.5))
                    }else{
                        Button {
                            text.removeAll()
                        } label: {
                            Image(systemName: "xmark").foregroundColor(Color(.label).opacity(0.5))
                        }
                    }
                    
                    TextField("Search by keyword...".localized(language), text: $text).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                        .foregroundColor(Color(.label).opacity(0.5))
                    
                    
                }.padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                
                LanguageButton(width: 38.0, height: 40.0)
                    .padding(.top, 6)
                    .padding(.trailing, 5)
            }.background()
            ScrollView {
                LazyVStack {
                    ForEach(dealsView.orders, id: \.id) { deal in
                        if text == "" || (deal.buyer.uppercased().contains(text.uppercased())
                                          || deal.salesman.uppercased().contains(text.uppercased())
                                          || deal.name.uppercased().contains(text.uppercased())
                                          || deal.id == text) {
                            DealsInfoView(deal: deal)
                        }
                    }
                    Spacer().frame(height: 130)
                }.refreshable {
                    dealsView.getDeals()
                }
            }
        }
    }
}

struct DealsView_Previews: PreviewProvider {
    static var previews: some View {
        DealsView().environmentObject(DealsViewModel())
    }
}
