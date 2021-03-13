//
//  LoginController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit
import Firebase

class LoginController: UIViewController{
    // MARK: - Properties
    let iconImage = UIImageView.iconImage
    let loginButton = UIButton.createAuthButton(title: "Log in", vc: self, selector: #selector(loginDidTap))
    let dontHaveAnAccountButton = UIButton.createAuthAttributedButton(regularString: "Don't have an account? ", highlightedString: "Sign Up", target:self, selector: #selector(dontHaveAnAccountButtonDidTap) )
    
    /// Password View/Field
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordView: InputContainerView = {
        return InputContainerView(image: UIImage.loginPasswordIcon, textField: self.passwordTextField)
    }()
    
    /// Email View/Fields
    let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailView: InputContainerView = {
        return InputContainerView(image: UIImage.loginEmailIcon, textField: self.emailTextField)
    }()
    
    private var loginViewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Selectors
    @objc func loginDidTap(){
        
        guard let email = self.emailTextField.text,
              let password = self.passwordTextField.text else {
            print("DEBUG: Failed to get textfield values")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dontHaveAnAccountButtonDidTap(){
        let registrationController = RegisterController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == self.emailTextField {
            self.loginViewModel.email = sender.text
        }else {
            self.loginViewModel.password = sender.text
        }
        
        self.checkFormStatus()
    }
    
    // MARK: - Helpers
    private func checkFormStatus(){
        if self.loginViewModel.formIsValid {
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    private func setupUI(){
        self.view.backgroundColor = .systemPurple
        self.navigationController?.navigationBar.isHidden = true
        
        self.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        
        self.setupTopCenterAuthView(subview: self.iconImage)
        
        let _ = UIStackView.setupStackView(with: self, subviews: [self.emailView, self.passwordView,self.loginButton], topAnchor: self.iconImage.bottomAnchor)
        
        self.view.addSubview(self.dontHaveAnAccountButton)
        
        self.dontHaveAnAccountButton.anchor(left:self.view.leftAnchor, bottom:self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        self.emailTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
}


