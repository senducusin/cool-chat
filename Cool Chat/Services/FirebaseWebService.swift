//
//  FirebaseWebService.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Firebase



struct FirebaseWebService {
    static func fetchUsers(completion:@escaping(Result<[User],Error>)->()){
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            
            guard error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            var users = [User]()
            snapshot?.documents.forEach({ document in
                if let user = User(document.data()){
                    users.append(user)
                }
            })
            completion(.success(users))
        }
    }
}
