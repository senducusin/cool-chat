//
//  Message.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Firebase

struct Message {
    let content: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    let isFromCurrentUser: Bool
    var messageType: MessageType = .text
    
    var chatPartnerId: String {
        return self.isFromCurrentUser ? self.toId : self.fromId
    }
}

extension Message {
    init(dictionary: [String:Any]){
        self.content = dictionary["content"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        
        if let fetchedType = dictionary["messageType"] as? String {
            for messageType in MessageType.allCases {
                if fetchedType == messageType.rawValue {
                    self.messageType = messageType
                }
            }
        }
       
    }
}

enum MessageType:String, CaseIterable {
    case text = "text"
    case image = "message"
}
