//
//  RegisterController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

class RegisterController: UIViewController{
    // MARK: - Properties
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage.registerPhotoImage, for: .normal)
        button.tintColor =  .white
        button.addTarget(self, action: #selector(addPhotoButtonDidTap), for: .touchUpInside)
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // Email
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailView: InputContainerView = {
        return InputContainerView(image: UIImage.loginEmailIcon, textField: self.emailTextField)
    }()
    
    // Fullname
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    
    private lazy var fullNameView: InputContainerView = {
        return InputContainerView(image: UIImage.registerInfoIcon, textField: self.fullNameTextField)
    }()
    
    // Username
     let usernameTextField = CustomTextField(placeholder: "Username")
    
    private lazy var usernameView: InputContainerView = {
        return InputContainerView(image: UIImage.registerInfoIcon, textField: self.usernameTextField)
    }()
    
    // Password View/Field
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordView: InputContainerView = {
        return InputContainerView(image: UIImage.loginPasswordIcon, textField: self.passwordTextField)
    }()
    
    let signUpButton = UIButton.createAuthButton(title: "Sign Up", vc: self, selector: #selector(signUpDidTap))
    
    let alreadyHaveAnAccountButton =  UIButton.createAuthAttributedButton(regularString: "Already have an account? ", highlightedString: "Log In", target:self, selector: #selector(alreadyHaveAnAccountButtonDidTap) )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Selectors
    @objc func addPhotoButtonDidTap(){
        print("select photo")
    }
    
    @objc func signUpDidTap(){
        print("trying to signup")
    }
    
    @objc func alreadyHaveAnAccountButtonDidTap(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func setupUI(){
        self.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        
        self.setupTopCenterAuthView(subview: addPhotoButton)
        
        let _ = UIStackView.setupStackView(with: self, subviews: [self.emailView,self.fullNameView, self.usernameView, self.passwordView, self.signUpButton], topAnchor: self.addPhotoButton.bottomAnchor)
        
        self.view.addSubview(self.alreadyHaveAnAccountButton)
        
        self.alreadyHaveAnAccountButton.anchor(left:self.view.leftAnchor, bottom:self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
}
