//
//  NewConversationViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/18/21.
//

import UIKit

struct NewConversationViewModel {
    let user: User
    
    var fullName: String {
        return user.fullname.capitalized
    }
    
    var username: String {
        return user.username.capitalized
    }
    
    var contentMode: UIView.ContentMode{
        if let _ = URL(string: user.profileImageUrl) {
            return .scaleAspectFill
        }
        return .scaleAspectFit
    }
    
    var imageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
}

