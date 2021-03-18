//
//  User.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Foundation

typealias jsonDictionary = [String:Any]

struct User:Encodable {
    let uid: String
    var profileImageUrl: String = ""
    let username: String
    let fullname: String
    let email: String
}

extension User {
    init?(_ dictionary: jsonDictionary){
        guard let uid = dictionary["uid"] as? String,
              let username = dictionary["username"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let email = dictionary["email"] as? String else {
            return nil
        }
        self.uid = uid
        self.username = username
        self.fullname = fullname
        self.email = email
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
}
