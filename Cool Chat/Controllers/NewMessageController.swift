//
//  NewMessageController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

class NewMessageController: UITableViewController {
    // MARK: - Properties
    var users = [User]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsers()
        self.setupUI()
    }
    
    @objc func cancelButtonDidTap(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    private func fetchUsers(){
        FirebaseWebService.fetchUsers { result in
            switch(result){
            
            case .success(let users):
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showQuickMessage(withText: error.localizedDescription, messageType: .error)
            }
        }
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "New Message"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap))
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(NewMessageTableViewCell.self, forCellReuseIdentifier: UITableViewCell.newMessageTVCellIdentifier)
        self.tableView.rowHeight = 80
    }
}

// MARK: - UITableViewDataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.newMessageTVCellIdentifier, for: indexPath) as! NewMessageTableViewCell
        
        let user = users[indexPath.row]
        cell.configure(user: user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
