//
//  UIStackView+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

extension UIStackView{
    static public func setupStackView(with viewController:UIViewController, subviews:[UIView], topAnchor:NSLayoutYAxisAnchor ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)

        stackView.axis = .vertical
        stackView.spacing = 16
        viewController.view.addSubview(stackView)

        stackView.anchor(top: topAnchor, left: viewController.view.leftAnchor, right: viewController.view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        return stackView
    }
}
