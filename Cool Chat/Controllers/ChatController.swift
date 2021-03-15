//
//  ChatController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

class ChatController: UICollectionViewController{
    // MARK: - Properties
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
        self.fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - API
    func fetchMessages(){
        FirebaseWebService.fetchMessages(for: user) { messages in
            self.messages = messages
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: false)
            }
        }
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.collectionView.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = user.username
        
        self.collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.chatCollectionViewCell)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.keyboardDismissMode = .onDrag
    }
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.chatCollectionViewCell, for: indexPath) as! ChatCollectionViewCell
        
        cell.message = messages[indexPath.row]
        cell.message?.user = self.user
        
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let estimatedSizeCell = ChatCollectionViewCell(frame:frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}


extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        FirebaseWebService.uploadMessage(message, to: user) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showQuickMessage(withText: error.localizedDescription, messageType: .error)
                }
                return
            }
            
            inputView.clearMessageText()
            
        }
    }
}
