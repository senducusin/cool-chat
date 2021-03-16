//
//  CustomInputAccessoryView.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message:String)
}

class CustomInputAccessoryView: UIView {
    // MARK: - Properties
    var optionsViewSetToHide: NSLayoutConstraint!
    var optionsViewSetToShow: NSLayoutConstraint!
    
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
    
    private lazy var chevronRight: UIButton = {
        let button = UIButton(type:  .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemPurple
        button.addTarget(self, action: #selector(chevronButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var optionsView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        view.backgroundColor = .green
        return view
    }()
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.autoresizingMask = .flexibleHeight
        self.backgroundColor = .white
        
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = .init(width: 0, height: -8)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.setupSendButton()
        self.setupMessageInputTextView()
        self.setupPlaceholderLabel()
        
        self.setupOptionsView()
        
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
        guard let message = self.messageInputTextView.text else {return}
        self.delegate?.inputView(self, wantsToSend: message)
    }
    
    @objc func messageInputDidChange() {
        self.placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    @objc func chevronButtonDidTap(){
        
        if self.optionsViewSetToShow.isActive {
            self.setOptionsViewMode(show: false)
        }else{
            self.setOptionsViewMode(show: true)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.optionsView.layoutIfNeeded()
       }
    }
    
    // MARK: - Helpers
    public func clearMessageText() {
        self.messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
    
    private func setupSendButton(){
        self.addSubview(self.sendButton)
        self.sendButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        self.sendButton.setDimensions(height: 50, width: 50)
    }
    
    private func setupMessageInputTextView(){
        self.addSubview(self.messageInputTextView)
        self.messageInputTextView.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingBottom: 4, paddingRight: 8)
    }
    
    private func setupPlaceholderLabel(){
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft:  4)
        self.placeholderLabel.centerY(inView: messageInputTextView)
    }
    
    private func setupOptionsView(){
        self.addSubview(self.optionsView)
        
        self.optionsView.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: self.messageInputTextView.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 10)
        self.optionsView.setHeight(height: 25)
    
        self.setupOptionsViewMode()
        self.setupOptionsInOptionView()
    }
    
    private func setupOptionsViewMode(){
        optionsViewSetToHide = self.optionsView.widthAnchor.constraint(equalToConstant: 25)
        optionsViewSetToShow = self.optionsView.widthAnchor.constraint(equalToConstant: 100)
        optionsViewSetToHide?.isActive = true
    }
    
    private func setupOptionsInOptionView(){
        self.optionsView.addSubview(self.chevronRight)
        self.chevronRight.anchor(top:self.optionsView.topAnchor, right: self.optionsView.rightAnchor)
        self.chevronRight.setDimensions(height: 24, width: 24)
    }
    
    private func setOptionsViewMode(show enable:Bool) {
        self.optionsViewSetToHide?.isActive = !enable
        self.optionsViewSetToShow?.isActive = enable
    }
    
}
