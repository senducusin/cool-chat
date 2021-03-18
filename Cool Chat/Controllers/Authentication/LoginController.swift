//
//  LoginController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit
import Firebase

protocol AuthenticationDelegate: class {
    func authenticationComplete()
}

class LoginController: UIViewController{
    // MARK: - Properties
    weak var delegate: AuthenticationDelegate?
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
        
        self.showLoader(true, withText: "Logging in")
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else{
                if let error = error {
                    print(error.localizedDescription)
                    self.showQuickMessage(withText: error.localizedDescription, messageType: .error)
                }
                
                return
            }
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func dontHaveAnAccountButtonDidTap(){
        let registrationController = RegisterController()
        registrationController.delegate = delegate
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
            self.loginButton.backgroundColor = .white
        }else{
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = .themeLightGray
        }
    }
    
    private func setupUI(){
        self.view.backgroundColor = .systemPurple
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .themeBlack
        
        self.view.addSubview(self.iconImage)
        self.iconImage.centerX(inView: self.view)
        self.iconImage.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        self.iconImage.setDimensions(height: 140, width: 190)
        
        let _ = UIStackView.setupStackView(with: self, subviews: [self.emailView, self.passwordView,self.loginButton], topAnchor: self.iconImage.bottomAnchor)
        
        self.view.addSubview(self.dontHaveAnAccountButton)
        
        self.iconImage.setWidth(width: 400)
        
        self.dontHaveAnAccountButton.anchor(left:self.view.leftAnchor, bottom:self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        self.emailTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
}

extension LoginController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !textField.text!.isEmpty else {
            return false
        }
        
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {

            self.loginDidTap()
        }
        
        return true
    }
}


