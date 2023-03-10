//
//  localService.swift
//  kursova
//
//  Created by Artem Leschenko on 10.03.2023.
//

import Foundation


enum Language: String {
    case ukraine = "uk"
    case english_us = "en"
    case spanish = "es"
    case deich = "de"
    case france = "fr"
}

class LocalizationService {

    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")

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
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
}
