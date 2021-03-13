//
//  LoginViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import Foundation

struct LoginViewModel{
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
