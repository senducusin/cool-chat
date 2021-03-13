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
    let tableView = UITableView.createTable()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.conversationPlusIcon, for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.addTarget(self, action: #selector(newMessageButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticateUser()
        self.setupUI()
        self.setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Selectors
    @objc private func showProfileDidTap(){
        /*
         Temporary Codes
         */
        self.logoutUser()
        
    }
    
    @objc private func newMessageButtonDidTap(){
        let newMessageController = NewMessageController()
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
    
    // MARK: - Helpers
    private func presentLoginScreen(animated: Bool){
        DispatchQueue.main.async {
            let loginController = LoginController()
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: UITableViewCell.conversationTVCellIdentifier, for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
