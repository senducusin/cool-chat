//
//  UIButton+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UIButton {
    public static func createLoginButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for:.normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemRed
        button.setHeight(height: 50)
        return button
    }
}
