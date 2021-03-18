//
//  Conversation.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import Foundation
import Firebase

struct Conversation {
    let user :User
    let message: Message
    let type: DocumentChangeType
}
