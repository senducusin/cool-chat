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
        
        self.view.addSubview(iconImage)
        self.iconImage.translatesAutoresizingMaskIntoConstraints = false
        
    }
}


