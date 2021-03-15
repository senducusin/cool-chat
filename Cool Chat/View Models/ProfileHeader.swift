//
//  ProfileHeader.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func dismissController()
}

class ProfileHeader: UIView {
    // MARK: - Properties
    weak var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet {self.populateUserData()}
    }
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(exitDidTap), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4.0
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame:CGRect){
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func exitDidTap(){
        self.delegate?.dismissController()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        self.profileImageView.setDimensions(height: 200, width: 200)
        self.profileImageView.layer.cornerRadius = 200 / 2
        
        self.addSubview(self.profileImageView)
        self.profileImageView.centerX(inView: self)
        self.profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [self.fullnameLabel, self.usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: self.profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(self.dismissButton)
        self.dismissButton.anchor(top:topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        self.dismissButton.setDimensions(height: 48, width: 48)
        
    }
    
    private func populateUserData(){
        guard let user = self.user,
              let urlString = self.user?.profileImageUrl,
              let url = URL(string: urlString) else {return}
        
        self.fullnameLabel.text = user.fullname
        self.usernameLabel.text = "@\(user.username)"
        self.profileImageView.sd_setImage(with: url, completed: nil)
    }
}
