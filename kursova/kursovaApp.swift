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
    
    
    @StateObject var lotView: LotViewModel = LotViewModel()
    
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

class LanguageManager {
    
    func setLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {

    /// Localizes a string using given language from Language enum.
    /// - parameter language: The language that will be used to localized string.
    /// - Returns: localized string.
    func localized(_ language: Language) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }

    /// Localizes a string using given language from Language enum.
    ///  - Parameters:
    ///  - language: The language that will be used to localized string.
    ///  - args:  dynamic arguments provided for the localized string.
    /// - Returns: localized string.
    func localized(_ language: Language, args arguments: CVarArg...) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return String(format: localized(bundle: bundle), arguments: arguments)
    }

    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
