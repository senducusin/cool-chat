//
//  ConversationViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import Foundation
import Firebase

struct ConversationViewModel {
    let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    var timestampFont: UIFont {
        return messageIsSeen ? UIFont.systemFont(ofSize: 12) : UIFont.boldSystemFont(ofSize: 12)
    }
    
    var messageTextFont: UIFont {
        
        switch conversation.message.messageType {

        case .text:
            return messageIsSeen ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 14)
        case .image:
            return messageIsSeen ? UIFont.boldSystemFont(ofSize: 14).italic() : UIFont.italicSystemFont(ofSize: 14)
        }
    }
    
    var fontColor: UIColor {
        return messageIsSeen ? UIColor.lightGray : UIColor.white
    }
    
    private var messageIsSeen: Bool {
        if let _ = conversation.message.seenTimestamp {
            return true
        }else{
            return false
        }
    }
    
    var username: String {
        return conversation.user.username.capitalized
    }
    
    var content: String {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return conversation.message.content
        }
        
        switch conversation.message.messageType {

        case .text:
            return conversation.message.content
        case .image:
            
            if conversation.message.fromId == uid {
                return "You've sent an image"
            }
            
            return "Sent an image"
        }
    }
}
