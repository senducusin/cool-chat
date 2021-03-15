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
    
    static func uploadMessage(_ message: String, to user: User, completion:((Error?) -> ())?){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = [
            "text": message,
            "fromId": currentUid,
            "toId":user.uid,
            "timestamp": Timestamp(date: Date())
        ] as [String : Any]
        
        /// Add message to current user
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { (_) in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchMessages(for user: User, completion:@escaping([Message])->()){
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
}
