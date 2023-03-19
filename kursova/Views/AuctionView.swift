//
//  AuctionsView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI

struct AuctionsView: View {
    //Для мови
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    //Для фільтру
    @State private var showFilters = false
    ///Для фільтру ціни
    @State private var priceFilterOn = false
    @State private var minPrice = ""
    @State private var maxPrice = ""
    ///Для фільтру дати
    @State private var dateFilterOn = false
    @State private var selectedDate = Date()
    ///Для фільтру поточного користувача
    @State private var currentFilterOn = false
    ///Для пошукового слова
    @State private var searchInputWord = ""
    
    @EnvironmentObject var lotView: LotViewModel
    ///Для оптимізації пошуку по слову
    var searchWord:String{
        get{return searchInputWord == "" ? " ": searchInputWord}
    }
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    if searchInputWord == ""{
                        Image(systemName: "magnifyingglass").foregroundColor(Color(.label).opacity(0.5))
                    }else{
                        Button {
                            searchInputWord.removeAll()
                        } label: {
                            Image(systemName: "xmark").foregroundColor(Color(.label).opacity(0.5))
                        }
                    }
                    
                    TextField("Search by keyword...".localized(language), text: $searchInputWord).autocorrectionDisabled(true).textInputAutocapitalization(.never)
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
                        .opacity(0.65)
                        .fontWeight(.bold)
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showFilters ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: showFilters)
                        .opacity(0.65)
                }.padding(.top, 5)
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
                    //Фільтр ціни
                    Divider()
                    HStack{
                        Text("Price".localized(language) + ": ").opacity(0.75)
  
                        TextField("From".localized(language), text: $minPrice)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        TextField("To".localized(language), text: $maxPrice).textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        CustomToggle(switchMark: $priceFilterOn)
                    }
                    //Фільтр дати
                    HStack {
                        Text("Date from:".localized(language)).opacity(0.75)
                       
                        DatePicker("",
                                   selection: $selectedDate,
                                   in: Calendar.current.date(from: DateComponents(year: 2010, month: 1, day: 1))!...Date(),
                                   displayedComponents: .date
                        ).frame(maxWidth: 120)
                        Spacer()
                        CustomToggle(switchMark: $dateFilterOn)
                    }
                    //Фільтр теперішнього користувача
                    HStack{
                        Text("Current user status: None".localized(language)).opacity(0.75)
                        Spacer()
                        CustomToggle(switchMark: $currentFilterOn)
                    }
                    
                    Divider()
                }
            }.padding(.horizontal)
            
            ScrollView{

                Spacer().frame(height: 10)
                ForEach(0..<lotView.lotsList.count, id: \.self){item in
                    let lot = lotView.lotsList[item]

                    if lot.mainText.uppercased().contains(searchWord.uppercased())
                        && (priceFilterOn ? (lot.currentPrice >= Int(minPrice) ?? 0 && lot.currentPrice <= Int(maxPrice) ?? 1000000) : true) //Фильтр цены
                        && (dateFilterOn ? (lot.date >= selectedDate): true)
                        && (currentFilterOn ? (lot.currentPerson == "None"): true){ //Фильтр даты
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
