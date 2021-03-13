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
    
    func createUser(withCredential credential:RegistrationCredential, profileImage:UIImage?, completion:@escaping(RegistrationError?)->()){
        if let profileImage = profileImage {
            self.uploadProfilePictureToFirebaseThenRegister(profileImage: profileImage, credential: credential, completion: completion)
        }else {
            self.registerUserToFirebase(credential: credential, completion: completion)
        }
    }
}

extension AuthService {
    private func uploadProfilePictureToFirebaseThenRegister(profileImage: UIImage, credential:RegistrationCredential?, completion:@escaping((RegistrationError?)->())){
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3),
              var newUser = credential else {
            completion(.imageCompressionError)
            return
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { meta, error  in
            guard error == nil else {
                completion(.uploadImageError)
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {
                    completion(.invalidUrlFormat)
                    return
                }
                newUser.profileImageUrl = profileImageUrl
                self.registerUserToFirebase(credential: credential) { (error) in
                    completion(error)
                }
            }
        }
    }
    
    private func registerUserToFirebase(credential:RegistrationCredential?, completion:@escaping((RegistrationError?)->())){
        guard var credential = credential else {
            completion(.invalidCredential)
            return
        }
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
            guard error == nil else{
                completion(.registrationErrorTryAnotherEmailAddress)
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.unableToRetrieveUID)
                return
            }
            credential.uid = uid
            
            guard let data = credential.toDictionary() else {
                completion(.invalidData)
                return
            }
            
            Firestore.firestore().collection("users").document(uid).setData(data) { (error) in
                guard error == nil else {
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                    }
                    completion(.fireStoreError)
                    return
                }
            }
            
            completion(nil)
//            self.dismiss(animated: true, completion: nil)
        }
    }
}
