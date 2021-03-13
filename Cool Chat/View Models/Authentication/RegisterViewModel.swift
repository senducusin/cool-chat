//
//  RegisterViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Foundation

struct RegisterViewModel {
    var email: String?
    var fullName: String?
    var username: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            password?.isEmpty == false &&
            username?.isEmpty == false &&
            fullName?.isEmpty == false
    }
}
