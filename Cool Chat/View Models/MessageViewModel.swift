//
//  MessageViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

struct MessageViewModel {
    private let message: Message

    var messageBackgroundColor: UIColor{
        return message.isFromCurrentUser ? .themeBlue : .themeDarkGray
    }

    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageUrl)
    }
    
    init(message:Message){
        self.message = message
    }
}

