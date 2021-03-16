//
//  FirebaseWebService.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Firebase

struct FirebaseWebService {
    static func fetchUsers(completion:@escaping(Result<[User],Error>)->()){
        COLLECTION_USERS.getDocuments { snapshot, error in
            
            guard error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            guard var users:[User] = snapshot?.documents.map({ User($0.data())! }) else { return }
            
            if let i = users.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid }){
                print(users[i].fullname)
                users.remove(at: i)
            }
            
            completion(.success(users))
            
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, withTypeOf messageType: MessageType,  completion:((Error?) -> ())?){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = [
            "content": message,
            "fromId": currentUid,
            "toId":user.uid,
            "timestamp": Timestamp(date: Date()),
            "messageType": messageType.rawValue,
            
        ] as [String : Any]
        
        /// Add message to current user
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { (_) in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
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
    
    static func fetchConversations(completion: @escaping([Conversation]) -> ()){
        var conversations = [Conversation]()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(with: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                  
                    conversations.append(conversation)
                    completion(conversations)
                }
                
            })
        }
    }
    
    static func fetchUser(with uid: String, completion:@escaping(User)->()){
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else {
                return
            }
            
            if let user = User(dictionary) {
                completion(user)
            }
        }
    }
    
    static func uploadImageAsMessage(withImage imageMessage:UIImage, to user:User, withTypeOf type:MessageType, completion:@escaping(Error?)->()){
        guard let imageData = imageMessage.jpegData(compressionQuality: 0.3) else {
            return
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/imageMessages/\(filename)")
        
        ref.putData(imageData, metadata: nil) { meta, error in
            guard error == nil else {
                if let error = error {
                    completion(error)
                }
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString,
                      error == nil else {
                    if let error = error {
                        completion(error)
                    }else {
                        // another error
                    }
                    return
                }
                
                //success
                uploadMessage(imageUrl, to: user, withTypeOf: .image, completion: completion)
            }
        }

    }
}
