//
//  RegistrationCredential.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Foundation

struct RegistrationCredential : Encodable{
    var fullname:String
    var email:String
    var username:String
    var password:String
    var profileImageUrl:String?
    var uid:String?
}
