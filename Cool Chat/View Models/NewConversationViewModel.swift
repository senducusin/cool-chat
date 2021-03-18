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
    
}

