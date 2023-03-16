//
//  localService.swift
//  kursova
//
//  Created by Artem Leschenko on 10.03.2023.
//

import Foundation
import SwiftUI


enum Language: String {
    case ukraine = "uk"
    case english_us = "en"
    case spanish = "es"
    case deich = "de"
    case france = "fr"
}

class LocalizationService {

    static let shared = LocalizationService()

    private init() {}
    
    var language: Language {
        get {
            
            if let languageString = UserDefaults.standard.string(forKey: "language") {
                return Language(rawValue: languageString) ?? .english_us
            } else if let systemLanguageCode = Locale.current.language.languageCode?.identifier,
                let systemLanguage = Language(rawValue: systemLanguageCode) {
                return systemLanguage
            } else {
                return .english_us
            }
            
        } set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
            }
        }
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


    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
