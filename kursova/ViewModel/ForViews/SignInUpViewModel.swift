//
//  SignInUpViewModel.swift
//  kursova
//
//  Created by Artem Leschenko on 14.04.2023.
//

import Foundation
import SwiftUI

class SignInUpViewModel: ObservableObject {
    
    private var language = LocalizationService.shared.language
    
    @Published var email = ""
    @Published var pass = ""
    @Published var isAlert = false
    @Published var textAlert = ""
    @Published var isProfileShow = false
    
    @Published var name = ""
    @Published var confirmPass = ""
    
    func signIn() {
        AuthService.shared.signIn(email: email, password: pass) { [weak self] result in
            switch result{
            case .success(_):
                self?.email.removeAll()
                UserDefaults.standard.set(true, forKey: "UserLoginStatus")
            case .failure(let error):
                self?.textAlert = "\(error.localizedDescription)"
                self?.isAlert.toggle()
            }
        }
    }
    
    func signUp() {
        guard pass == confirmPass else{
            textAlert = "Password mismatch".localized(language)
            confirmPass.removeAll()
            isAlert.toggle()
            return
        }
        guard name.count > 3 else{
            textAlert = "Too short name and surname".localized(language)
            isAlert.toggle()
            return
        }
        
        AuthService.shared.signUp(email: email, password: pass, name: name) { [weak self] result in
            switch result {
            case .success(let user):
                self?.textAlert = "Registration with ".localized(self!.language) + user.email!
                self?.isAlert.toggle()
                self?.name.removeAll()
                self?.pass.removeAll()
                self?.confirmPass.removeAll()
                self?.email.removeAll()
            case .failure(let error):
                self?.textAlert = "\(error.localizedDescription)!"
                self?.isAlert.toggle()
            }
        }
    }
    
    func requestAuthorization() {
        // Создание экземпляра центра уведомлений
        let center = UNUserNotificationCenter.current()

        // Запрос разрешения на отправку уведомлений
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения на отправку уведомлений: \(error)")
            } else if granted {
                print("Разрешение на отправку уведомлений получено.")
            } else {
                print("Разрешение на отправку уведомлений не получено.")
            }
        }
    } 
    
}
