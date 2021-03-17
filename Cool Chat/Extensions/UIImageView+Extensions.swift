//
//  UIImageView+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UIImageView {
    static let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
        imageView.tintColor = .white
        return imageView
    }()
}
