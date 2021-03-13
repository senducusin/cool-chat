//
//  UIButton+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

extension UIButton {
    public static func createAuthButton(title:String, vc:Any, selector:Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle(title, for:.normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(vc, action: selector, for: .touchUpInside)
        return button
    }
    
    public static func createAuthAttributedButton(regularString: String, highlightedString: String,target:Any, selector:Selector)->UIButton{
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: regularString,attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: highlightedString,attributes:[.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }
}
