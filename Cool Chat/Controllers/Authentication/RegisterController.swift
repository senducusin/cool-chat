//
//  RegisterController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit
import Firebase

class RegisterController: UIViewController{
    // MARK: - Properties
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage.registerPhotoImage, for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 0.7)
        button.addTarget(self, action: #selector(addPhotoButtonDidTap), for: .touchUpInside)
        button.layer.cornerRadius = 30

        button.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        button.layer.borderWidth = 3
        return button
    }()
    
    /// Email
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailView: InputContainerView = {
        return InputContainerView(image: UIImage.loginEmailIcon, textField: self.emailTextField)
    }()
    
    /// Fullname
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    
    private lazy var fullNameView: InputContainerView = {
        return InputContainerView(image: UIImage.registerInfoIcon, textField: self.fullNameTextField)
    }()
    
    /// Username
     let usernameTextField = CustomTextField(placeholder: "Username")
    
    private lazy var usernameView: InputContainerView = {
        return InputContainerView(image: UIImage.registerInfoIcon, textField: self.usernameTextField)
    }()
    
    /// Password View/Field
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordView: InputContainerView = {
        return InputContainerView(image: UIImage.loginPasswordIcon, textField: self.passwordTextField)
    }()
    
    private let signUpButton = UIButton.createAuthButton(title: "Sign Up", vc: self, selector: #selector(signUpDidTap))
    
    private let alreadyHaveAnAccountButton =  UIButton.createAuthAttributedButton(regularString: "Already have an account? ", highlightedString: "Log In", target:self, selector: #selector(alreadyHaveAnAccountButtonDidTap) )
    
    private var registerViewModel = RegisterViewModel()
    private var profileImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Selectors
    @objc func addPhotoButtonDidTap(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func signUpDidTap(){
        guard let email = self.emailTextField.text,
              let username = self.usernameTextField.text?.lowercased(),
              let fullName = self.fullNameTextField.text,
              let password = self.passwordTextField.text else {
            return
        }
        
        self.showLoader(true)
        
        let newUserCredential = RegistrationCredential(fullname: fullName, email: email, username: username, password: password)
        
        AuthService.shared.createUser(withCredential: newUserCredential, profileImage: self.profileImage) { (error) in
            guard error == nil else {
                if let error = error {
                    print(error.localizedDescription)
                    self.showQuickMessage(withText: error.localizedDescription, messageType: .error)
                }
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func alreadyHaveAnAccountButtonDidTap(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == self.emailTextField {
            self.registerViewModel.email = sender.text
            
        } else if sender == self.fullNameTextField {
            self.registerViewModel.fullName = sender.text
            
        } else if sender == self.passwordTextField {
            self.registerViewModel.password = sender.text
            
        } else if sender == self.usernameTextField {
            self.registerViewModel.username = sender.text
            
        }
        
        self.checkFormStatus()
    }
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func cancelButtonDidTap(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    private func setupNotificationObservers(for textFields:[UITextField]){
        for textField in textFields {
            textField.addTarget(self, action: #selector(self.textDidChange(sender:)), for: .editingChanged)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func checkFormStatus(){
        if self.registerViewModel.formIsValid {
            self.signUpButton.isEnabled = true
            self.signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            self.signUpButton.isEnabled = false
            self.signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    private func setupUI(){
        self.view.addGradientToView(with: [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor])
        
        self.setupTopCenterAuthView(subview: addPhotoButton, squareDimension: 200)
        
        let _ = UIStackView.setupStackView(with: self, subviews: [self.emailView,self.fullNameView, self.usernameView, self.passwordView, self.signUpButton], topAnchor: self.addPhotoButton.bottomAnchor)
        
        self.view.addSubview(self.alreadyHaveAnAccountButton)
        
        self.alreadyHaveAnAccountButton.anchor(left:self.view.leftAnchor, bottom:self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        self.setupNotificationObservers(for: [self.emailTextField, self.fullNameTextField, self.usernameTextField, self.passwordTextField])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap))
    }

}

// MARK: - UIImagePickerController Delegate
extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        self.profileImage = image
        self.addPhotoButton.setBackgroundImage(nil, for: .normal)
        self.addPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.addPhotoButton.layer.cornerRadius = 200 / 2
        self.addPhotoButton.layer.masksToBounds = true
        self.addPhotoButton.imageView?.clipsToBounds = true
        self.addPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
}
