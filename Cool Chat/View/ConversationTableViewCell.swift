//
//  ConversationTableViewCell.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import UIKit
import Firebase

class ConversationTableViewCell: UITableViewCell {
    // MARK: - Properties
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(self.profileImageView)
        self.profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        self.profileImageView.setDimensions(height: 50, width: 50)
        self.profileImageView.layer.cornerRadius = 50/2
        self.profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [self.usernameLabel, self.messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: self.profileImageView)
        stack.anchor(left: self.profileImageView.rightAnchor, right: self.rightAnchor, paddingTop: 20,  paddingLeft: 7, paddingRight: 12)
        
        addSubview(self.timestampLabel)
        self.timestampLabel.anchor(top:topAnchor, right:rightAnchor, paddingTop: 20, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configure(){
        
        guard let conversation = conversation else {return}
        let viewModel = ConversationViewModel(conversation:conversation)
        
        self.usernameLabel.text = conversation.user.username
        self.messageTextLabel.text = conversation.message.content
        
        self.timestampLabel.text = viewModel.timestamp
        self.profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        if let seen = conversation.message.seenTimestamp {
            
            self.usernameLabel.font = UIFont.systemFont(ofSize: 14)
            self.timestampLabel.font = UIFont.systemFont(ofSize: 12)
            self.messageTextLabel.font = UIFont.systemFont(ofSize: 14)
        } else {
            self.usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
            self.timestampLabel.font = UIFont.boldSystemFont(ofSize: 12)
            self.messageTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
}
