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
    func setProfile(user: MainUser, completion:@escaping (Result<MainUser, Error>)->()){
        
        userRef.document(user.id).setData(user.representation) { error in
            if let error = error{
                completion(.failure(error))
            }else{
                completion(.success(user ))
            }
        }
    }
    
    //Функция, которая заберает инфу про пользователя с бд
    func getProfile(completion: @escaping(Result<MainUser, Error>)->()){
        
        guard let user = AuthService.shared.currentUser else {return}
        userRef.document(user.uid).getDocument { docSnapshot, error in
        
            guard let snap = docSnapshot else {return}
            
            guard let data = snap.data() else {return}
            
            guard let userName = data["name"] as? String else {return}
            guard let userID = data["id"] as? String else {return}
            guard let userEmail = data["email"] as? String else {return}
            guard let userBalance = data["balance"] as? Int else {return}
            guard let image = data["image"] as? String else {return}
            
            let user = MainUser(name: userName,
                                id: userID,
                                balance: userBalance,
                                email: userEmail,
                                image: image)
            
            completion(.success(user))
        }

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
    func getImageUrl(imagePath: String, path:String,completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(path)/\(imagePath).jpg")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error getting download URL for image \(imagePath): \(error)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
    
    //Загружаэм картинку в бд
    func uploadUserImage(image:UIImage){
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        guard let uid = AuthService.shared.currentUser?.uid else {return}
        let ref = Storage.storage().reference().child("users_logo/\(uid).jpg")
        
        ref.putData(imageData, metadata: nil){url, error in
            if error != nil{
                print("\nSomething wrong!!!!!\n")
                return
            }
            print("Succses upload image")
        }
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