//
//  AythService.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import Foundation
import FirebaseAuth

class AuthService{
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    var currentUser: User? {
        UserDefaults.standard.set( auth.currentUser != nil, forKey: "UserLoginStatus" )
        return auth.currentUser
    }
       
    func signUp(email:String, password:String, name:String, completion:@escaping(Result<User, Error>)->() ){
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result{
                let user = MUser(name: name, id: result.user.uid, email: email, image: "")
                DBUserService.shared.setProfile(user: user) { resultDB in
                    switch resultDB {
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                completion(.success(result.user))
            }else if let error = error{
                completion(.failure(error))
            }
        }
    }
    
    func signIn(email:String, password:String, completion:@escaping(Result<User, Error>)->() ){
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result{
                completion(.success(result.user))
            }else if let error = error{
                completion(.failure(error))
            }
        }
    }

    func signOut(){
        try? Auth.auth().signOut()
    }
}
