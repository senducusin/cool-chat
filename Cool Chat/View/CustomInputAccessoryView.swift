//
//  CustomInputAccessoryView.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

class CustomInputAccessoryView: UIView {
    // MARK: - Properties
    private let messageInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label  = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.autoresizingMask = .flexibleHeight
        self.backgroundColor = .white
        
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = .init(width: 0, height: -8)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.addSubview(self.sendButton)
        self.sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        self.sendButton.setDimensions(height: 50, width: 50)
        
        self.addSubview(self.messageInputTextView)
        self.messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 4, paddingRight: 8)
        
        self.addSubview(placeholderLabel)
        self.placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft:  4)
        self.placeholderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageInputDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Selectors
    @objc func sendButtonDidTap(){
        print("Sending message")
    }
    
    @objc func messageInputDidChange() {
        self.placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
}
