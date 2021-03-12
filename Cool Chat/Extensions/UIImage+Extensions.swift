//
//  UIImage+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UIImage {
    
    static let LoginPasswordIcon: UIImage? = {
        let image = UIImage(systemName: "lock")
        return image
    }()
    
    static let LoginEmailIcon: UIImage? = {
        let image = UIImage(systemName: "envelope")
        return image
    }()
}
