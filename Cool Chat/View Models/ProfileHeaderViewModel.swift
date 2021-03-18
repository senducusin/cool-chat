//
//  ProfileHeaderViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/18/21.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var imageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return "@\(user.username)"
    }
    
    var fullname: String {
        return user.fullname.capitalized
    }
}
