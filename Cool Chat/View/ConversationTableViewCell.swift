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
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    let cellSelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeDarkGray
        return view
    }()
    
    let cellRegularView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeBlack
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.selectedBackgroundView = self.cellRegularView
        }else{
            self.selectedBackgroundView = self.cellSelectionView
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print(isSelected)
        self.backgroundColor = .themeBlack
        
        self.addSubview(self.profileImageView)
        self.profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        self.profileImageView.setDimensions(height: 50, width: 50)
        self.profileImageView.layer.cornerRadius = 50/2
        self.profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [self.usernameLabel, self.messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        self.addSubview(stack)
        stack.centerY(inView: self.profileImageView)
        stack.anchor(left: self.profileImageView.rightAnchor, right: self.rightAnchor, paddingTop: 20,  paddingLeft: 7, paddingRight: 12)
        
        self.addSubview(self.timestampLabel)
        self.timestampLabel.anchor(top:topAnchor, right:rightAnchor, paddingTop: 20, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configure(){
        
        guard let conversation = conversation else {return}
        let viewModel = ConversationViewModel(conversation:conversation)
        
        self.usernameLabel.text = conversation.user.username.capitalized
        self.messageTextLabel.text = conversation.message.content
        
        self.timestampLabel.text = viewModel.timestamp
        self.profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        self.messageTextLabel.font = viewModel.mediumFont
        self.timestampLabel.font = viewModel.smallFont
        
        self.messageTextLabel.textColor = viewModel.fontColor
        self.timestampLabel.textColor = viewModel.fontColor
    }
}
