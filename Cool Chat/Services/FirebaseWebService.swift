//
//  FirebaseWebService.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Firebase

enum FirebaseWebServiceListener{
    case messageListener
    case conversationListener
}

class FirebaseWebService {
    
    static let shared = FirebaseWebService()
    
    var fetchMessageListener: ListenerRegistration?
    var fetchConversationListener: ListenerRegistration?
    
    func fetchUsers(completion:@escaping(Result<[User],Error>)->()){
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
    
    func uploadMessage(_ message: String, to user: User, withTypeOf messageType: MessageType,  completion:((Error?) -> ())?){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let currentTime = Timestamp(date: Date())
        
        var data = [
            "content": message,
            "fromId": currentUid,
            "toId":user.uid,
            "timestamp": currentTime,
            "messageType": messageType.rawValue,
            "seenTimestamp": ""
            
        ] as [String : Any]
        
        /// Add message to current user
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { (_) in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
           
            // The currentUid typed the message hence seen the message already
            data["seenTimestamp"] = currentTime
            COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
           
        }
    }
    
    func fetchMessages(for user: User, completion:@escaping([Message])->()){
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        self.fetchMessageListener =  query.addSnapshotListener {(snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                }
            })
            completion(messages)
        }
        
    }
    
    func fetchConversations(completion: @escaping([Conversation]) -> ()){
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        self.fetchConversationListener = query.addSnapshotListener { (snapshot, error) in
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
    
    func fetchUser(with uid: String, completion:@escaping(User)->()){
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else {
                return
            }
            
            if let user = User(dictionary) {
                completion(user)
            }
        }
    }
    
    func uploadImageAsMessage(withImage imageMessage:UIImage, to user:User, withTypeOf type:MessageType, completion:@escaping(Error?)->()){
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
                self.uploadMessage(imageUrl, to: user, withTypeOf: .image, completion: completion)
            }
        }
    }
    
    func removeListener(_ listener: FirebaseWebServiceListener){
        switch(listener){
        
        case .messageListener:
            guard let listener = self.fetchMessageListener else {
                return
            }
            listener.remove()
            
        case .conversationListener:
            guard let listener = self.fetchConversationListener else {
                return
            }
            listener.remove()
            
        }
        
    }
    
    func updateRecentMessage(with user: User) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let key = "seenTimestamp"
        
        COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).updateData([key:FieldValue.serverTimestamp()]){  error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
           
        }
    }
}
