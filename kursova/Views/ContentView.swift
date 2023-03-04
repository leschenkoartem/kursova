//
//  ContentView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 22.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var lotView: LotViewModel = LotViewModel()
    @StateObject var profileView = AccountViewModel()
    @State var selector:Tab = .hammer
    @State var isUsserLogin:Bool
    
    var body: some View {
        
        
        if isUsserLogin == true{
            
            ZStack{
                
                    TabView(selection: $selector) {
                        switch selector{
                        case .hammer:
                            AuctionsView().toolbar(.hidden, for: .tabBar).environmentObject(AccountViewModel()).environmentObject(LotViewModel())

                        case .house:
                            if AuthService.shared.currentUser != nil{
                                HomeView(isUserLogin: $isUsserLogin).toolbar(.hidden, for: .tabBar).environmentObject(AccountViewModel()).environmentObject(LotViewModel())

                            }
                        }
                    }
                
                
                VStack{
                    CustomTabBar(selectedTab: $selector).padding(.bottom, 10)
                        .shadow(radius: 5)

                }.frame(maxHeight: .infinity, alignment: .bottom)
                    
                
            }
            
        }else{
            SignInView(isUserLogin: $isUsserLogin)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isUsserLogin: true)
    }
}
