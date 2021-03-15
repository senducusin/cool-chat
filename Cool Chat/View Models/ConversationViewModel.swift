//
//  ConversationViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import Foundation

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
}
