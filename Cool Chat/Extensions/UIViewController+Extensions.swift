//
//  UIViewController+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UIViewController {
    public func addGradientToView(with cgColors:[CGColor]){
        let gradient = CAGradientLayer()
        gradient.colors = cgColors
        gradient.locations = [0, 1]
        self.view.layer.addSublayer(gradient)
        
        gradient.frame = self.view.frame
    }
    
    public func setupTopCenterAuthView(subview:UIView, squareDimension:CGFloat = 120) {
        self.view.addSubview(subview)
        subview.centerX(inView: view)
        subview.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        subview.setDimensions(height: squareDimension, width: squareDimension)
    }
}

extension UIViewController {
//    static let hud = JGProgressHUD(style: .dark)

    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
//    func showLoader(_ show: Bool, withText text: String? = "Loading") {
//        view.endEditing(true)
//        UIViewController.hud.textLabel.text = text
//
//        if show {
//            UIViewController.hud.show(in: view)
//        } else {
//            UIViewController.hud.dismiss()
//        }
//    }
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
