//
//  ChatCollectionViewCell.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    var message :Message? {
        didSet {configure()}
    }
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        
        return textView
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
//        self.backgroundColor = .gree
        
        self.addSubview(self.profileImageView)
        self.profileImageView.anchor(left:leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        self.profileImageView.setDimensions(height: 32, width: 32)
        self.profileImageView.layer.cornerRadius = 32/2
        
        addSubview(self.bubbleContainer)
        self.bubbleContainer.layer.cornerRadius = 12
        self.bubbleContainer.anchor(top:topAnchor)
        self.bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        /// Left Anchor
        self.bubbleLeftAnchor = self.bubbleContainer.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 12)
        self.bubbleLeftAnchor.isActive = false
        
        /// Right Anchor
        self.bubbleRightAnchor = self.bubbleContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        self.bubbleRightAnchor.isActive = false
        
        
        self.bubbleContainer.addSubview(textView)
        self.textView.anchor(top:self.bubbleContainer.topAnchor, left:bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configure(){
        guard let message = message else {return}
        let viewModel = MessageViewModel(message: message)
        
        self.bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        self.textView.textColor = viewModel.messageTextColor
        self.textView.text = message.text
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}

