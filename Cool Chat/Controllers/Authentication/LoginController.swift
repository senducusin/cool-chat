//
//  LoginController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

class LoginController: UIViewController{
    // MARK: - Properties
    let iconImage = UIImageView.iconImage
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for:.normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up",attributes:[.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(signUpDidTap), for: .touchUpInside)
        return button
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailView: InputContainerView = {
        return InputContainerView(image: UIImage.LoginEmailIcon, textField: self.emailTextField)
    }()
    
    private lazy var passwordView: InputContainerView = {
        return InputContainerView(image: UIImage.LoginPasswordIcon, textField: self.passwordTextField)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Selectors
    @objc func signUpDidTap(){
        let registrationController = RegisterController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.view.backgroundColor = .systemPurple
        self.navigationController?.navigationBar.isHidden = true
        
        self.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        
        self.setupIconImage()
        self.setupStackView()
        self.view.addSubview(self.signUpButton)
        self.signUpButton.anchor(left:self.view.leftAnchor, bottom:self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    private func setupIconImage(){
        self.view.addSubview(iconImage)
        self.iconImage.centerX(inView: view)
        self.iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        self.iconImage.setDimensions(height: 120, width: 120)
    }
    
    private func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [
                                        self.emailView,
                                        self.passwordView,
                                        self.loginButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        self.view.addSubview(stackView)
        
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
}


