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
        imageView.backgroundColor = .themeDarkGray
        imageView.tintColor = .themeLightGray
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        textView.isHidden = true
        
        return textView
    }()
    
    private lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.layer.cornerRadius = 13
        imageView.setDimensions(height: 155, width: 220)
        return imageView
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
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
        self.bubbleContainer.layer.cornerRadius = 16
        self.bubbleContainer.anchor(top:topAnchor, bottom: bottomAnchor)
        self.bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        
        /// Left Anchor
        self.bubbleLeftAnchor = self.bubbleContainer.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 12)
        self.bubbleLeftAnchor.isActive = false
        
        /// Right Anchor
        self.bubbleRightAnchor = self.bubbleContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        self.bubbleRightAnchor.isActive = false
        
        self.bubbleContainer.addSubview(self.textView)
        self.textView.anchor(
            top:self.bubbleContainer.topAnchor,
            left:self.bubbleContainer.leftAnchor,
            bottom: self.bubbleContainer.bottomAnchor,
            right: self.bubbleContainer.rightAnchor,
            paddingLeft: 6,
            paddingRight: 6
        )

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configure(){
        guard let message = message else {return}
        let viewModel = MessageViewModel(message: message)
        
        self.bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        
        self.textView.textColor = .white
        
        switch message.messageType {
        case .text:
            
            self.textView.isHidden = false
            self.messageImageView.removeFromSuperview()
            self.textView.text = message.content
        case .image:
            if let url = URL(string: message.content) {
                self.setupMessageImageView(url)
            }
            
        }
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, placeholderImage: UIImage(systemName: "person.crop.circle"))
    }
    
    private func setupMessageImageView(_ imageUrl:URL){
        
        self.messageImageView.setDimensions(height: 155, width: 220)
        self.bubbleContainer.addSubview(self.messageImageView)
        self.messageImageView.anchor(
            top:self.bubbleContainer.topAnchor,
            left: self.bubbleContainer.leftAnchor,
            bottom: self.bubbleContainer.bottomAnchor,
            right:self.bubbleContainer.rightAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingBottom: 8,
            paddingRight: 8
        )
        
        self.textView.isHidden = true
        self.messageImageView.isHidden = false
        self.messageImageView.sd_setImage(with: imageUrl)
    }
}

