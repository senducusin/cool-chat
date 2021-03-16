//
//  UIImage+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UIImage {
    
    static let loginPasswordIcon: UIImage? = {
        let image = UIImage(systemName: "lock")
        return image
    }()
    
    static let loginEmailIcon: UIImage? = {
        let image = UIImage(systemName: "envelope")
        return image
    }()
    
    static let registerPhotoImage: UIImage? = {
        let image = UIImage(systemName: "person.fill")
        return image
    }()
    
    static let registerInfoIcon: UIImage? = {
        let image = UIImage(systemName: "person")
        return image
    }()
    
    static let conversationPlusIcon: UIImage? = {
        let image = UIImage(systemName: "plus")
        return image
    }()
    
    static let chevronIcon: UIImage? = {
        let image = UIImage(systemName: "chevron.right")
        return image
    }()
    
    static let photoImage: UIImage? = {
        let image = UIImage(systemName: "photo")
        return image
    }()
    
    static let cameraImage: UIImage? = {
        let image = UIImage(systemName: "camera")
        return image
    }()
}
