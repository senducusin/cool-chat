//
//  AuthService.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Firebase
import UIKit

enum RegistrationError: Error {
    case imageCompressionError
    case uploadImageError
    case invalidUrlFormat
    case invalidCredential
    case registrationErrorTryAnotherEmailAddress
    case unableToRetrieveUID
    case invalidData
    case fireStoreError
}

struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email:String, password:String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(withCredential credential:RegistrationCredential, profileImage:UIImage?, completion:@escaping(Error?)->()){
        if let profileImage = profileImage {
            self.uploadProfilePictureToFirebaseThenRegister(profileImage: profileImage, credential: credential, completion: completion)
        }else {
            self.registerUserToFirebase(credential: credential, completion: completion)
        }
    }
}

extension AuthService {
    private func uploadProfilePictureToFirebaseThenRegister(profileImage: UIImage, credential:RegistrationCredential?, completion:@escaping((Error?)->())){
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3),
              var credential = credential else {
            completion(RegistrationError.imageCompressionError)
            return
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { meta, error  in
            guard error == nil else {
                if let error = error {
                    completion(error)
                }
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString,
                      error == nil else {
                    if let error = error {
                        completion(error)
                    }else {
                        completion(RegistrationError.invalidUrlFormat)
                    }
                    
                    return
                }
                credential.profileImageUrl = profileImageUrl
                self.registerUserToFirebase(credential: credential) { (error) in
                    completion(error)
                }
            }
        }
    }
    
    private func registerUserToFirebase(credential:RegistrationCredential?, completion:@escaping((Error?)->())){
        guard var credential = credential,
              let credentialPassword = credential.password else {
            completion(RegistrationError.invalidCredential)
            return
        }
        Auth.auth().createUser(withEmail: credential.email, password: credentialPassword) { (result, error) in
            guard error == nil else{
                if let error = error {
                    completion(error)
                }
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(RegistrationError.unableToRetrieveUID)
                return
            }
            credential.uid = uid
            credential.password = nil
            
            guard let data = credential.toDictionary() else {
                completion(RegistrationError.invalidData)
                return
            }
            
            Firestore.firestore().collection("users").document(uid).setData(data) { (error) in
                guard error == nil else {
                    if let error = error {
                        completion(error)
                    }
                    return
                }
            }
            
            completion(nil)
        }
    }
}
