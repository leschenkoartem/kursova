//
//  DatbaseService.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 21.02.2023.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseStorage


class DBUserService{
    
    
    static var shared = DBUserService()
    //1) делаем переменную обращения датабазы 2) Делаем ссылку на список "users"
    let dB = Firestore.firestore()
    
    var userRef:CollectionReference{
        return dB.collection("users")
    }
        
    
    //Делаем инит приватным для запрета создания еще одного
    private init(){ }
    
    
    //Запись юзера в базу даных
    func setProfile(user: MUser, completion:@escaping (Result<MUser, Error>)->()){
        
        userRef.document(user.id).setData(user.representation) { error in
            if let error = error{
                completion(.failure(error))
            }else{
                completion(.success(user ))
            }
        }
    }
    
    //Функция, которая заберает инфу про пользователя с бд
    func getProfile() async throws -> MUser {
        guard let currentUser = AuthService.shared.currentUser else { throw AppError.currentUserNil }
        
        let docSnapshot = try await userRef.document(currentUser.uid).getDocument()
        guard let data = docSnapshot.data() else { throw AppError.dataNotFound }
        guard let userName = data["name"] as? String else { throw AppError.userNameNotFound }
        guard let userID = data["id"] as? String else { throw AppError.userIDNotFound }
        guard let userEmail = data["email"] as? String else { throw AppError.userEmailNotFound }
        guard let userBalance = data["balance"] as? Int else { throw AppError.userBalanceNotFound }
        guard let image = data["image"] as? String else { throw AppError.userImageNotFound }
        
        let userObject = MUser(name: userName, id: userID, balance: userBalance, email: userEmail, image: image)
        return userObject
    }

    func updateBalance(for userId: String, amountToAdd: Double, completion: @escaping (Error?) -> Void) -> Void{
        let userRef = userRef.document(userId)

        // Атомарное обновление поля "balance" для документа с указанным идентификатором пользователя
        userRef.updateData(["balance": FieldValue.increment(amountToAdd)]) { error in
            if let error = error {
                print("Ошибка при добавлении суммы на баланс пользователя: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Сумма успешно добавлена на баланс пользователя")
                completion(nil)
            }
        }
    }
    
    //Получаем ЮРЛ картинки
    func getImageUrl(imagePath: String, path: String) async throws -> URL {
        let storageRef = Storage.storage().reference().child("\(path)/\(imagePath).jpg")
        do {
            let downloadUrl = try await storageRef.downloadURL()
            return downloadUrl
        } catch {
            print("Error getting download URL for image \(imagePath): \(error)")
            throw error
        }
    }
    
    //Загружаэм картинку в бд
    func uploadUserImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
        guard let uid = AuthService.shared.currentUser?.uid else { return }
        
        let ref = Storage.storage().reference().child("users_logo/\(uid).jpg")
        
        ref.putData(imageData)
        print("Success upload image")
        
    }
    
    //Обновляем данные пользователя по картинке
    func updateUserPhotoUrl(userId: String, newPhotoUrl: String) {
        let userRef = userRef.document(userId)
        userRef.updateData(["image": newPhotoUrl]) { error in
            if let error = error {
                print("Error updating photo URL for user \(error)")
            } else {
                print("Successfully updated photo URL for user ")
            }
        }
    }
}

enum AppError: Error {
    case currentUserNil
    case dataNotFound
    case userNameNotFound
    case userIDNotFound
    case userEmailNotFound
    case userBalanceNotFound
    case userImageNotFound
    case downloadURLNotFound
}

