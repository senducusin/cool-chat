//
//  ImagePreviewController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/16/21.
//

import UIKit

class ImagePreviewController: UIViewController {
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let imagePreview: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public var imageURL:URL!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.view.backgroundColor = .white
        
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 10
        self.scrollView.delegate = self
        
        self.view.addSubview(self.scrollView)
        self.scrollView.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.anchor(top:self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        
        self.scrollView.addSubview(self.imagePreview)
        self.imagePreview.anchor(top:self.scrollView.topAnchor, left: self.scrollView.leftAnchor, bottom: self.scrollView.bottomAnchor, right: self.scrollView.rightAnchor)
        self.imagePreview.setDimensions(height: self.view.frame.height, width: self.view.frame.width)
        self.imagePreview.sd_setImage(with: imageURL)
         
    }
}

extension ImagePreviewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePreview
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imagePreview.image {
                let ratioWidth = imagePreview.frame.width / image.size.width
                let ratioHeight = imagePreview.frame.height / image.size.height
                
                let ratio = ratioWidth < ratioHeight ? ratioWidth :ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > self.imagePreview.frame.width
                let left = (conditionLeft ? newWidth - self.imagePreview.frame.width : (self.scrollView.frame.width - self.scrollView.contentSize.width)) * 0.5
                
                let conditionTop = newHeight*scrollView.zoomScale > self.imagePreview.frame.height
                let top = 0.5 * (conditionTop ? newHeight - self.imagePreview.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        }else{
            scrollView.contentInset = .zero
        }
    }
}
