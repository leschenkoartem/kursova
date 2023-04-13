//
//  ContentView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 22.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var lotView = LotViewModel()
    @StateObject var profileView = AccountViewModel()
    @State var selector: Tab = .hammer
    
    @AppStorage("UserLoginStatus")
    var userLogIn = UserDefaults.standard.bool(forKey: "UserLoginStatus")
    
    var body: some View {
        if userLogIn {
            ZStack {
                TabView(selection: $selector) {
                    switch selector{
                    case .newspaper:
                        DealsView()
                            .toolbar(.hidden, for: .tabBar)
                    case .hammer:
                        AuctionsView()
                            .toolbar(.hidden, for: .tabBar)
                            .environmentObject(profileView)
                            .environmentObject(lotView)
                            .blur(radius: scenePhase == .inactive ? 10: 0)
                    case .house:
                            HomeView()
                                .toolbar(.hidden, for: .tabBar)
                                .environmentObject(profileView)
                                .environmentObject(lotView)
                                .blur(radius: scenePhase == .inactive ? 10: 0)
                    }
                }
                VStack{
                    CustomTabBar(selectedTab: $selector)
                        .padding(.bottom, 10)
                        .shadow(radius: 5)
                }.frame(maxHeight: .infinity, alignment: .bottom)
            }
        } else {
            SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
