//
//  ProfileFooter.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import UIKit

protocol  ProfileFooterDelegate: class {
    func handleLogoutCurrentUser()
}

class ProfileFooter: UIView {
    // MARK: - Properties
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(logoutDidTap), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ProfileFooterDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc private func logoutDidTap(){
        self.delegate?.handleLogoutCurrentUser()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        addSubview(self.logoutButton)
        self.logoutButton.anchor(left: leftAnchor, right:rightAnchor, paddingLeft: 32, paddingRight: 32)
        self.logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.logoutButton.centerY(inView: self)
    }
}
