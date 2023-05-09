//
//  KursachAuctionsApp.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023
//

import SwiftUI
import Firebase

@main
struct KursachAuctionsApp: App {
    //Firestore
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var lotView = LotViewModel()
    @StateObject var profileView = AccountViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profileView)
                .environmentObject(lotView)
                .onAppear { UIApplication.shared.applicationIconBadgeNumber = 0 }
        }
    }
}


//подключаем Firebase
class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

//Для закрытия клавиатуры
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


