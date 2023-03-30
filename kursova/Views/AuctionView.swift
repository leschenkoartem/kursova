//
//  AuctionsView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI

struct AuctionsView: View {
    var vm = AuctionViewModel()
    
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
    ///Для фільтру власника користувача
    @State private var filterCrearor = UserDefaults.standard.bool(forKey: "filterCrearor")
    ///Для фільтру послідовності
    @State private var observedQueue = 0
    ///Для пошукового слова
    @State private var searchInputWord = ""
    
    @EnvironmentObject var lotView: LotViewModel
    
    ///Для оптимізації пошуку по слову
    var searchWord:String{
        get{return searchInputWord == "" ? " ": searchInputWord}
    }
    
    var body: some View {
        ZStack{
            
            VStack{
                Spacer().frame(height: 100)
                ScrollView{
                    Spacer().frame(height: 10)
    //                Rectangle().foregroundColor(.red).cornerRadius(12)
    //                Rectangle().frame(height: 200)
    ///Отдел с фильтрами ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    ForEach(0..<lotView.lotsList.count, id: \.self){item in

                        let lot = vm.getQueue(observedQueue: observedQueue, list: lotView.lotsList)[item]

                        let redactedLot  = vm.getLot(priceFilterOn: priceFilterOn,
                                             dateFilterOn: dateFilterOn,
                                             currentFilterOn: currentFilterOn,
                                             filterCrearor: filterCrearor,
                                             lot: lot,
                                             searchWord: searchWord,
                                             selectedDate: selectedDate,
                                             minPrice: minPrice,
                                             maxPrice: maxPrice)

                        if redactedLot != nil { //Фильтр даты
                            SmallLot(selfViewModel: SmallLotViewModel(lot: redactedLot!))
                        }
                    }
    ///-----------------------------------------------------------------------------------------------------------------
                    Spacer().frame(width: 130)
                }.scrollDismissesKeyboard(.immediately)
                    .refreshable {
                        lotView.getLots()
                    }
            }
            
            VStack{
                VStack(spacing: 0) {
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
                    }.background()
                    
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
                                Spacer().frame(width: 30)
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
                            //Фільтр власника користувача
                            HStack{
                                Text("Hide your own auctions:".localized(language)).opacity(0.75)
                                Spacer()
                                CustomToggle(switchMark: $filterCrearor)
                                    .onChange(of: filterCrearor) { newValue in
                                        UserDefaults.standard.set(newValue, forKey: "filterCrearor")
                                    }
                            }
                            //Фільтр для налаштування черги відображення
                            HStack{
                                Text("Sort by:".localized(language)).opacity(0.75)
                                Spacer()
                                Picker("", selection: $observedQueue) {
                                    Text("Newest first".localized(language)).tag(0)
                                    Text("Oldest first".localized(language)).tag(1)
                                    Text("Less popular".localized(language)).tag(2)
                                    Text("Most popular".localized(language)).tag(3)
                                }.frame(minWidth: 250)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .foregroundColor(Color(.label))
                            }
                            Divider()
                        }
                        
                    }.padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .padding(7)
                        .background()
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: 400)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.bottom)
            .onAppear{
                lotView.getLots()
            }
    }
}

struct AuctionsView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionsView().environmentObject(LotViewModel())
    }
}
