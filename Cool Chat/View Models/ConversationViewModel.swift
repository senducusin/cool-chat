//
//  ConversationViewModel.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/18/21.
//

import Foundation

struct ConversationViewModel {
    var conversationsDictionary = [String:Conversation]()
    private var conversations = [Conversation]()
    
    var conversation: Conversation? {
        didSet{
            self.sync()
        }
    }
    
    private mutating func sync(){
        guard let conversation = self.conversation else {
            return
        }
        
        let message = conversation.message
        
        if conversation.type == .added {
            self.conversationsDictionary[message.chatPartnerId] = conversation
            
        } else if conversation.type == .removed {
            self.conversationsDictionary[message.chatPartnerId] = nil
        }
        self.conversations = Array(self.conversationsDictionary.values).reversed()
    }
    
    var numberOfConversation: Int {
        return conversations.count
    }
    
    public func conversationAt(index:Int) -> Conversation{
        return conversations[index]
    }
    
    public func conversationWithUserAt(index:Int) -> User{
        return conversations[index].user
    }
}
