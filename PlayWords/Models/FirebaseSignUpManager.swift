//
//  FirebaseSignUp.swift
//  PlayWords
//
//  Created by Shani Halali on 01/08/2025.
//

import Foundation
import FirebaseDatabase

class FirebaseSignupManager {
    
    static let create = FirebaseSignupManager()
    
    private let databaseURL = "https://word-game---ios-default-rtdb.europe-west1.firebasedatabase.app"
    
    private var ref: DatabaseReference
    
    private init() {
        self.ref = Database.database(url: databaseURL).reference().child("users")
    }
    
    func isAvaliableEmail(email: String, completion: @escaping (Bool, String?) -> Void) {
        let formattedEmail = formatEmail(email: email)
        
        //check if email not taken
        ref.child(formattedEmail).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                completion(true, "Email avaliable!")
            }else{
                completion(false, "Email is already taken")
                
            }
        }
    }
    
    func formatEmail(email: String) -> String {
        return email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
    }
    
    func isAvaliableUsername(username: String, completion: @escaping (Bool, String?) -> Void) {
        
        self.ref.observeSingleEvent(of: .value) { allUsers in
            for child in allUsers.children {
                if let userSnapshot = child as? DataSnapshot,
                   let userData = userSnapshot.value as? [String: Any],
                   let existingUsername = userData["username"] as? String {
                    
                    if existingUsername == username {
                        completion(false, "Username is already taken")
                        return
                    }
                }
            }
            completion(true,"username avaliable!")
            
        }
    }
    
    func createNewAccount(email: String, username: String, password: String, difficulty: String, language: String, completion: @escaping (Bool, String?) -> Void) {
        let key = formatEmail(email: email)
        
        let newUser: [String: Any] = [
            "email": email,
            "username": username,
            "password": password,
            "difficulty": difficulty,
            "lan": language,
            "score": 0
        ]
        
        self.ref.child(key).setValue(newUser) { error, _ in
            if let error = error {
                completion(false, "Failed to create new account: \(error.localizedDescription)")
            } else {
                completion(true, "Created new account \(key)")
            }
        }
    }
    
    
}
