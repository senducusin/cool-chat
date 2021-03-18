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
    
    private let noConversations: UILabel = {
        let label = UILabel()
        label.text = "No Conversation"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = false
        return label
    }()
    
    private let newConversationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.conversationPlusIcon, for: .normal)
        button.backgroundColor = .themeDarkBlue
        button.tintColor = .white
        
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .init(width:0, height:6)
        button.layer.shadowColor = UIColor.themeDarkBlue.cgColor
        
        button.addTarget(self, action: #selector(newConversationButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var viewModel = ConversationViewModel()
    
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
    
    @objc private func newConversationButtonDidTap(){
        let newMessageController = NewConversationController()
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
        FirebaseWebService.shared.fetchConversations { conversations in
            conversations.forEach { [weak self] conversation in
                self?.viewModel.conversation = conversation
                self?.tableView.reloadData()
                self?.hideTableView(hide: self?.viewModel.conversationIsEmpty)
            }
        }
    }
    
    // MARK: - Helpers
    private func hideTableView(hide:Bool?){
        self.tableView.isHidden = hide ?? true
        self.noConversations.isHidden = !(hide ?? false)
    }
    
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
        self.noConversations.frame = self.view.bounds
        self.view.backgroundColor = .themeBlack
        self.tableView.backgroundColor = .themeBlack
        self.tableView.isHidden = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "Conversations"
        
        self.view.addSubview(self.noConversations)
        self.view.addSubview(self.tableView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.createProfileButton(target: self, selector: #selector(showProfileDidTap))
        
        self.view.addSubview(self.newConversationButton)
        self.newConversationButton.setDimensions(height: 56, width: 56)
        self.newConversationButton.layer.cornerRadius = 56 / 2
        self.newConversationButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
}

// MARK: - TableView Datasource and Delegate
extension ConversationsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfConversation
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: UITableViewCell.conversationTVCellIdentifier, for: indexPath) as! ConversationTableViewCell
        let conversation = self.viewModel.conversationAt(index: indexPath.row)
        cell.conversation = conversation
        print("trig \(conversation.message.content)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let user = self.viewModel.conversationWithUserAt(index: indexPath.row)
        self.showChatController(forUser: user)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = self.viewModel.conversationWithUserAt(index: indexPath.row)
            FirebaseWebService.shared.deleteConversation(withUser: user) { error in
                guard error == nil else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - NewMessageController Delegate
extension ConversationsController: NewConversationControllerDelegate{
    
    func controller(_ controller: NewConversationController, wantsToStartChatWith user: User) {
        
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
