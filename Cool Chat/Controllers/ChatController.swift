//
//  ChatController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

class ChatController: UICollectionViewController{
    // MARK: - Properties
    
    var fromCurrentUser = false
    private let user: User
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        inputView.delegate = self
        return inputView
    }()
    private var messages = [Message]()
    
    // MARK: - Lifecycle
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override var inputAccessoryView: UIView? {
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.collectionView.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = user.username
        
        self.collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.chatCollectionViewCell)
        self.collectionView.alwaysBounceVertical = true
    }
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.chatCollectionViewCell, for: indexPath) as! ChatCollectionViewCell
        
        cell.message = messages[indexPath.row]
        
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}


extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        inputView.messageInputTextView.text = nil
        
        let message = Message(text: message, isFromCurrentUser: fromCurrentUser)
        messages.append(message)
        self.collectionView.reloadData()
        fromCurrentUser.toggle()
    }
    
}
