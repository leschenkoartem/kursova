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


class DBLotsService{
    
    
    static var shared = DBLotsService()
    //1) делаем переменную обращения датабазы 2) Делаем ссылку на список "users"
    let dB = Firestore.firestore()
    
    var lotRef:CollectionReference{
        return dB.collection("lots")
    }

    //Делаем инит приватным для запрета создания еще одного
    private init(){ }
    
    
    //Добавление лота
    func addLotToFirestore(lot: LotStruct) {
        
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
    func getLots(options: LotQueryOptions, completion: @escaping (Result<[LotStruct], Error>) -> Void) {
        
        //Фільтри на стороні клієнта
        var query: Query = lotRef
    
        if options.dateFilterOn, let selectedDate = options.selectedDate{
            query = query.whereField("date", isGreaterThan: selectedDate)
        }
            
        query.getDocuments { qSnap, error in
            guard let qSnap = qSnap else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            print(Date().description)
            let lots = qSnap.documents.compactMap { doc -> LotStruct? in
                guard let id = doc["id"] as? String,
                      let idCurrentPerson = doc["idCurrentPerson"] as? String,
                      let mainText = doc["mainText"] as? String,
                      let idCreator = doc["idCreator"] as? String,
                      let currentPrice = doc["currentPrice"] as? Int,
                      let currentPerson = doc["currentPerson"] as? String,
                      let currentEmail = doc["currentEmail"] as? String,
                      let informationText = doc["informationText"] as? String,
                      let seePeopleId = doc["seePeopleId"] as? [String],
                      let date = doc["date"] as? Timestamp,
                      let image = doc["image"] as? String else {
                    return nil
                }
                return LotStruct(id: id,
                                  idCreator: idCreator,
                                  idCurrentPerson: idCurrentPerson,
                                  mainText: mainText,
                                  currentPrice: currentPrice,
                                  currentPerson: currentPerson,
                                  currentEmail: currentEmail,
                                  informationText: informationText,
                                  date: date.dateValue(),
                                  seePeopleId: seePeopleId,
                                  image: image)
            }
            
            completion(.success(lots))
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
    
    
    //Загружаем картинку лота в бд
    func uploadLotImage(image:UIImage, LotId:String){
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
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
    
    
    // Удаление фото лота
    func deleteLotPhoto(LotId: String) {
        
        Storage.storage().reference().child("lots_loogo/\(LotId).jpg").delete() { err in
            if let err = err {
                print("Ошибка при удалении документа: \(err)")
            } else {
                print("Документ успешно удален")
            }
        }
    }
}


struct LotQueryOptions {
    var observedQueue: Int?
    var searchWord: String?
    var selectedDate: Date?
    var minPrice: String?
    var maxPrice: String?
    var priceFilterOn: Bool = false
    var dateFilterOn: Bool = false
    var currentFilterOn: Bool = false
    var filterCreator: Bool = UserDefaults.standard.bool(forKey: "filterCrearor")
}
