//
//  NewConversationTableViewCell.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit
import SDWebImage

class NewConversationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .themeLightGray
        imageView.backgroundColor = .themeDarkGray
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = "username"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Full Name"
        return label
    }()
    
    var user: User? {
        didSet { configure() }
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    private func setupUI(){
        self.backgroundColor = .themeBlack
        self.setupProfileImage()
        self.setupStackView()
    }
    
    private func setupProfileImage(){
        self.addSubview(profileImageView)
        self.profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        let imageDimension:CGFloat = 56
        self.profileImageView.setDimensions(height: imageDimension, width: imageDimension)
        self.profileImageView.layer.cornerRadius = imageDimension / 2
    }
    
    private func setupStackView(){
        let stack = UIStackView(arrangedSubviews: [self.usernameLabel, self.fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.centerY(inView: self.profileImageView, leftAnchor:  self.profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    public func configure(){
        
        if let user = user {
            let viewModel = NewConversationViewModel(user: user)
            self.fullnameLabel.text = viewModel.fullName
            self.usernameLabel.text = viewModel.username
            
            self.profileImageView.sd_setImage(with:viewModel.imageUrl,
                                              placeholderImage: UIImage(systemName: "person.crop.circle"))
      
            
        }
    }
}
