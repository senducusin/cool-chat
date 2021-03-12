//
//  UIViewController+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import Foundation
import UIKit

extension UIViewController {
    public func addGradientToView(with cgColors:[CGColor]){
        let gradient = CAGradientLayer()
        gradient.colors = cgColors
        gradient.locations = [0, 1]
        self.view.layer.addSublayer(gradient)
        
        gradient.frame = self.view.frame
    }
}
