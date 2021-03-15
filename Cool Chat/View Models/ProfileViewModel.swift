//
//  ProfileViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return"gear"
        }
    }
}
