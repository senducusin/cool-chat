//
//  ConversationsController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit
import Firebase

class ConversationsController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView.createTable(customCellClass: ConversationTableViewCell.self)
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.conversationPlusIcon, for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.addTarget(self, action: #selector(newMessageButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String:Conversation]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticateUser()
        self.setupUI()
        self.setupTableView()
        self.fetchConversations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Selectors
    @objc private func showProfileDidTap(){
        
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true, completion: nil)
    }
    
    @objc private func newMessageButtonDidTap(){
        let newMessageController = NewMessageController()
        newMessageController.delegate = self
        let nav = UINavigationController(rootViewController: newMessageController)
        present(nav,animated: true, completion: nil)
    }
    
    // MARK: - API
    func authenticateUser(){
        if Auth.auth().currentUser?.uid == nil {
            self.presentLoginScreen(animated: false)
        }
    }
    
    func logoutUser(){
        do {
            try Auth.auth().signOut()
            presentLoginScreen(animated: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchConversations(){
        self.conversationsDictionary.removeAll()
        FirebaseWebService.fetchConversations { conversations in
            self.conversations.removeAll()
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
                
            }
            self.conversations = Array(self.conversationsDictionary.values)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func showChatController(forUser user: User){
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func presentLoginScreen(animated: Bool){
        DispatchQueue.main.async {
            let loginController = LoginController()
            loginController.delegate = self
            let nav = UINavigationController(rootViewController: loginController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: animated, completion: nil)
        }
    }
    
    private func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupUI(){
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "Messages"
        
        self.view.addSubview(self.tableView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.createProfileButton(target: self, selector: #selector(showProfileDidTap))
        
        self.view.addSubview(self.newMessageButton)
        self.newMessageButton.setDimensions(height: 56, width: 56)
        self.newMessageButton.layer.cornerRadius = 56 / 2
        self.newMessageButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
}

// MARK: - TableView Datasource and Delegate
extension ConversationsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: UITableViewCell.conversationTVCellIdentifier, for: indexPath) as! ConversationTableViewCell
        let conversation = conversations[indexPath.row]
        cell.conversation = conversation
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let user = conversations[indexPath.row].user
        self.showChatController(forUser: user)
    }
}

// MARK: - NewMessageController Delegate
extension ConversationsController: NewMessageControllerDelegate{
    
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        
        dismiss(animated: true, completion: nil)
        self.showChatController(forUser: user)
    }
}

extension ConversationsController: ProfileControllerDelegate {
    func handleLogoutCurrentUser() {
        self.logoutUser()
    }
}

extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        self.dismiss(animated: true, completion: nil)
        self.setupUI()
        self.fetchConversations()
    }
}
