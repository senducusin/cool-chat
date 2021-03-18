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
    
    var smallFont: UIFont {
        return messageIsSeen ? UIFont.systemFont(ofSize: 12) : UIFont.boldSystemFont(ofSize: 12)
    }
    
    var mediumFont: UIFont {
        return messageIsSeen ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 14)
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
}
