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
    let loginButton = UIButton.createAuthButton(title: "Log in", vc: self, selector: #selector(loginDidTap))
    let dontHaveAnAccountButton = UIButton.createAuthAttributedButton(regularString: "Don't have an account? ", highlightedString: "Sign Up", target:self, selector: #selector(dontHaveAnAccountButtonDidTap) )
    
    // Password View/Field
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordView: InputContainerView = {
        return InputContainerView(image: UIImage.loginPasswordIcon, textField: self.passwordTextField)
    }()
    
    // Email View/Fields
    let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailView: InputContainerView = {
        return InputContainerView(image: UIImage.loginEmailIcon, textField: self.emailTextField)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Selectors
    @objc func loginDidTap(){
        print("trying to log in")
    }
    
    @objc func dontHaveAnAccountButtonDidTap(){
        let registrationController = RegisterController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.view.backgroundColor = .systemPurple
        self.navigationController?.navigationBar.isHidden = true
        
        self.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        
        self.setupTopCenterAuthView(subview: self.iconImage)
        
        let _ = UIStackView.setupStackView(with: self, subviews: [self.emailView, self.passwordView,self.loginButton], topAnchor: self.iconImage.bottomAnchor)
        
        self.view.addSubview(self.dontHaveAnAccountButton)
        
        self.dontHaveAnAccountButton.anchor(left:self.view.leftAnchor, bottom:self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
    }
}


