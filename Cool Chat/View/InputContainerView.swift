//
//  InputContainerView.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

class InputContainerView: UIView {
    init(image: UIImage?, textField: UITextField){
        super.init(frame: .zero)
        
        setHeight(height: 50)
    
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .white
        imageView.alpha = 0.87
        addSubview(imageView)
        
        imageView.centerY(inView: self)
        imageView.anchor(left:leftAnchor, paddingLeft: 8)
        imageView.setDimensions(height: 24, width: 28)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: imageView.rightAnchor, bottom: self.bottomAnchor, right:self.rightAnchor, paddingLeft: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left:leftAnchor, bottom:bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
