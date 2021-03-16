//
//  CustomInputAccessoryView.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message:String)
    func inputViewWantsToOpenPhotos()
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
    
    private lazy var showOptionsViewButton: UIButton = {
        let button = UIButton(type:  .system)
        button.setImage(UIImage.chevronIcon, for: .normal)
        button.tintColor = .systemPurple
        button.addTarget(self, action: #selector(showOptionsViewDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.photoImage, for: .normal)
        button.tintColor = .systemPurple
        button.isHidden = true
        button.addTarget(self, action: #selector(photoButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.cameraImage, for: .normal)
        button.tintColor = .systemPurple
        button.isHidden = true
        return button
    }()
    
    private var optionsView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
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
        guard !self.messageInputTextView.text.isEmpty,
              let message = self.messageInputTextView.text
               else {return}
        self.delegate?.inputView(self, wantsToSend: message)
    }
    
    @objc func messageInputDidChange() {
        self.placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    @objc func showOptionsViewDidTap(){
        self.animateOptionsView(show: true)
    }
    
    @objc func photoButtonDidTap(){
        self.delegate?.inputViewWantsToOpenPhotos()
    }
    
    // MARK: - Helpers
    public func clearMessageText() {
        self.messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
    
    private func animateOptionsView(show: Bool){
        self.setOptionsViewMode(show: show)
      
        UIView.animate(withDuration: 0.1) {
            self.optionsView.layoutIfNeeded()
       }
    }
    
    private func setupSendButton(){
        self.addSubview(self.sendButton)
        self.sendButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        self.sendButton.setDimensions(height: 50, width: 50)
    }
    
    private func setupMessageInputTextView(){
        self.addSubview(self.messageInputTextView)
        self.messageInputTextView.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingBottom: 4, paddingRight: 8)
        self.messageInputTextView.delegate = self
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
        optionsViewSetToShow = self.optionsView.widthAnchor.constraint(equalToConstant: 80)
        optionsViewSetToHide?.isActive = true
    }
    
    private func setupOptionsInOptionView(){
        self.setupShowViewButton()
        
        self.setupPhotoButton()
        self.setupCameraButton()
    }
    
    private func setupShowViewButton() {
        self.optionsView.addSubview(self.showOptionsViewButton)
        self.showOptionsViewButton.anchor(top:self.optionsView.topAnchor, right: self.optionsView.rightAnchor)
        self.showOptionsViewButton.setDimensions(height: 24, width: 24)
    }
    
    private func setupPhotoButton() {
        self.optionsView.addSubview(self.photoButton)
        self.photoButton.anchor(top:self.optionsView.topAnchor, right: self.optionsView.rightAnchor, paddingRight: 4)
        self.photoButton.setDimensions(height: 24, width: 28)
    }
    
    private func setupCameraButton() {
        self.optionsView.addSubview(self.cameraButton)
        self.cameraButton.anchor(top:self.optionsView.topAnchor, right: self.photoButton.leftAnchor, paddingRight: 10)
        self.cameraButton.setDimensions(height: 24, width: 28)
    }
    
    private func setOptionsViewMode(show enable:Bool) {
        self.optionsViewSetToShow?.isActive = enable
        self.optionsViewSetToHide?.isActive = !enable
        
        
        self.displayOptions(show: enable)
    }
    
    private func displayOptions(show: Bool){
        self.cameraButton.isHidden = !show
        self.photoButton.isHidden = !show
        self.showOptionsViewButton.isHidden = show
    }
}

extension CustomInputAccessoryView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.animateOptionsView(show: false)
    }
}
