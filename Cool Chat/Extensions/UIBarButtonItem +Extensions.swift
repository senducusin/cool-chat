//
//  UIBarButtonItem+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UIBarButtonItem {
    static public func createProfileButton(target:UIViewController, selector:Selector) -> UIBarButtonItem {
        let image = UIImage(systemName: "person.circle.fill")
        return UIBarButtonItem(image:image, style: .plain,  target: target, action: selector)
    }
}
