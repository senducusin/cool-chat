//
//  NewMessageTableViewCell.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPurple
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
}
