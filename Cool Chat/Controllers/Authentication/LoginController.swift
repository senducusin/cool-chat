//
//  LoginController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

class LoginController: UIViewController{
    // MARK: - Properties
    let iconImage = UIImageView.IconImage
    let emailContainerView = UIView.createContainerView()
    let passwordContainerView = UIView.createContainerView()
    let loginButton = UIButton.createLoginButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.view.backgroundColor = .systemPurple
        self.navigationController?.navigationBar.isHidden = true
        
        self.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        
        self.setupIconImage()
        self.setupStackView()
    }
    
    private func setupIconImage(){
        self.view.addSubview(iconImage)
        self.iconImage.centerX(inView: view)
        self.iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        self.iconImage.setDimensions(height: 120, width: 120)
    }
    
    private func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [
                                        self.emailContainerView,
                                        self.passwordContainerView,
                                        self.loginButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        self.view.addSubview(stackView)
        
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
}


