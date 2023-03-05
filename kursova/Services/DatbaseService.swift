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


class DatabaseService{
    
    
    static var shared = DatabaseService()
    //1) делаем переменную обращения датабазы 2) Делаем ссылку на список "users"
    let dB = Firestore.firestore()
    
    var userRef:CollectionReference{
        return dB.collection("users")
    }
    
    var lotRef:CollectionReference{
        return dB.collection("lots")
    }
    
   
    
    
    
    //Делаем инит приватным для запрета создания еще одного
    private init(){ }
    
    
    //Запись юзера в базу даных
    func setProfile(user: User_str, completion:@escaping (Result<User_str, Error>)->()){
        
        userRef.document(user.id).setData(user.representation) { error in
            if let error = error{
                completion(.failure(error))
            }else{
                completion(.success(user ))
            }
        }
    }
    
    //Функция, которая заберает инфу про пользователя с бд
    func getProfile(completion: @escaping(Result<User_str, Error>)->()){
        
        guard let user = AuthService.shared.currentUser else {return}
        userRef.document(user.uid).getDocument { docSnapshot, error in
        
            guard let snap = docSnapshot else {return}
            
            guard let data = snap.data() else {return}
            
            guard let userName = data["name"] as? String else {return}
            guard let userID = data["id"] as? String else {return}
            guard let userEmail = data["email"] as? String else {return}
            guard let userBalance = data["balance"] as? Int else {return}
            guard let image = data["image"] as? String else {return}
            
            let user = User_str(name: userName, id: userID, balance: userBalance, email: userEmail, image: image)
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
    
    
    
    
    //Добавление лота
    func addLotToFirestore(lot: Lot_str) {
        
        var docData: [String: Any] = lot.representation
        docData["idCreator"] = AuthService.shared.currentUser!.uid
        
        
        lotRef.document(lot.id).setData(lot.representation) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(self.lotRef)")
            }
        }
    }
    
    //Получение лота
    func getLots(completion: @escaping(Result<[Lot_str], Error>)->()){
        lotRef.getDocuments{ qSnap, error in
            if let qSnap = qSnap{
                var lots = [Lot_str]()
                for doc in qSnap.documents{
                    guard let id = doc["id"] as? String else {return}
                    guard let idCurrentPerson = doc["idCurrentPerson"] as? String else {return}
                    guard let mainText = doc["mainText"] as? String else {return}
                    guard let idCreator = doc["idCreator"] as? String else {return}
                    guard let currentPrice = doc["currentPrice"] as? Int else {return}
                    guard let currentPerson = doc["currentPerson"] as? String else {return}
                    guard let currentEmail = doc["currentEmail"] as? String else {return}
                    guard let informationText = doc["informationText"] as? String else {return}
                    guard let seePeopleId = doc["seePeopleId"] as? [String] else {return}
                    guard let date = doc["date"] as? Timestamp else {return}
                    guard let image = doc["image"] as? String else {return}
                    let lot = Lot_str(id: id, idCreator: idCreator, idCurrentPerson: idCurrentPerson, mainText: mainText, currentPrice: currentPrice, currentPerson: currentPerson, currentEmail:currentEmail, informationText: informationText, date: date.dateValue(), seePeopleId: seePeopleId, image: image)
                    lots.append(lot)
                }
                
                completion(.success(lots))
            }else if let error = error{
                completion(.failure(error))
            }
           
            }
        }
    
    
    // Удаление лота
    func deleteLotData(LotId: String) {
        
        dB.collection("lots").document(LotId).delete() { err in
            if let err = err {
                print("Ошибка при удалении документа: \(err)")
            } else {
                print("Документ успешно удален")
            }
        }
    }
    
    //Обновление лота после ставки
    func changeCurentDataLot(LotId: String, currentPrice:Int, currentPerson:String,idCurrentPerson:String, currentEmail:String){
        let lotRef = dB.collection("lots").document(LotId)
        lotRef.updateData(["currentPrice": currentPrice])
        lotRef.updateData(["currentPerson": currentPerson])
        lotRef.updateData(["idCurrentPerson": idCurrentPerson])
        lotRef.updateData(["currentEmail": currentEmail])
        
    }

    //Обновляет список айди наблюдателей
    func delPeoplSee(LotId:String, arrayID:[String]){
        let lotRef = dB.collection("lots").document(LotId)
        lotRef.updateData(["seePeopleId": arrayID]) { (error) in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
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
    
    //Загружаем картинку лота в бд
    func uploadLotImage(image:UIImage, LotId:String){
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {return}
        let ref = Storage.storage().reference().child("lots_loogo/\(LotId).jpg")
        
        ref.putData(imageData, metadata: nil){url, error in
            if error != nil{
                print("\nSomething wrong!!!!!\n")
                return
            }
            print("Succses upload image of lot")
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
    
    //Обновляем данные пользователя по картинке
    func updateLotPhotoUrl(LotId: String, newPhotoUrl: String) {
        let userRef = lotRef.document(LotId)
        userRef.updateData(["image": newPhotoUrl]) { error in
            if let error = error {
                print("Error updating photo URL for user \(error)")
            } else {
                print("Successfully updated photo URL for user ")
            }
        }
    }
    
}
