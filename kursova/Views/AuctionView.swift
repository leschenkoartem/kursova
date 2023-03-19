//
//  AuctionsView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI

struct AuctionsView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var priceFilterOn = false
    @State var minPrice = ""
    @State var maxPrice = ""
    @State private var selectedDate = Date()
    @State var dateFilterIn = false
    @State var showFilters = false
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
            HStack {
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
                    
                    TextField("Search by keyword...".localized(language), text: $searchWord).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                        .foregroundColor(Color(.label).opacity(0.5))
                    
                    
                }.padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                
                LanguageButton(width: 38.0, height: 40.0)
                    .padding(.top, 6)
                    .padding(.trailing, 5)
            }
            
            VStack{
                HStack{
                    Text("More filters".localized(language))
                    
                    Image(systemName: "chevron.down").rotationEffect(.degrees(showFilters ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: showFilters)
                }.padding(5)
                    .background()
                    .foregroundColor(Color(.label).opacity(0.75))
                    .onTapGesture {
                        withAnimation {
                            UIApplication.shared.endEditing()
                            showFilters.toggle()
                        }
                    }
                //Фильтры
                if showFilters{
                    Divider()
                    HStack{
                        Text("Price".localized(language) + ": ")
                        
                        Spacer()
                        
                        TextField("From".localized(language), text: $minPrice)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        TextField("To".localized(language), text: $maxPrice).textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        CustomToggle(switchMark: $priceFilterOn)
                    }
                    
                    
                    HStack {
                        Text("Date from:".localized(language))
                        
                        DatePicker("",
                                   selection: $selectedDate,
                                   in: Calendar.current.date(from: DateComponents(year: 2010, month: 1, day: 1))!...Date(),
                                   displayedComponents: .date
                        ).frame(maxWidth: 120)
                        Spacer()
                        CustomToggle(switchMark: $dateFilterIn)
                    }
                    Divider()
                }
            }.padding(.horizontal)
            
            ScrollView{

                Spacer().frame(height: 10)
                ForEach(0..<lotView.lotsList.count, id: \.self){item in
                    let lot = lotView.lotsList[item]

                    if lot.mainText.uppercased().contains(searchStringWord.uppercased())
                        && (priceFilterOn ? (lot.currentPrice >= Int(minPrice) ?? 0 && lot.currentPrice <= Int(maxPrice) ?? 1000000) : true) //Фильтр цены
                        && (dateFilterIn ? (lot.date >= selectedDate): true){ //Фильтр даты
                        SmallLot(selfViewModel: SmallLotViewModel(lot: lot))
                    }
                }
                Spacer().frame(height: 130)
            }
            
            Spacer()
        }.edgesIgnoringSafeArea(.bottom)
            .onAppear{
                lotView.getLots()
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
