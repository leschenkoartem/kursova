//
//  KursachAuctionsApp.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct KursachAuctionsApp: App {
    
    //Firestore
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(isUsserLogin: AuthService.shared.currentUser != nil)
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


