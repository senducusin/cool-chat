//
//  NewConversationController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/13/21.
//

import UIKit

protocol NewConversationControllerDelegate: class {
    func controller(_ controller: NewConversationController, wantsToStartChatWith user: User)
}

class NewConversationController: UITableViewController {
    // MARK: - Properties
    private var users = [User]()
    private var filteredUsers = [User]()
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    weak var delegate: NewConversationControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsers()
        self.setupUI()
    }
    
    @objc func cancelButtonDidTap(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - API
    private func fetchUsers(){
        FirebaseWebService.shared.fetchUsers { result in
            switch(result){
            
            case .success(let users):
                self.users = users.sorted(by:  { $0.username < $1.username })
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
        self.view.backgroundColor = .themeBlack
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "New Message"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap))
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(NewConversationTableViewCell.self, forCellReuseIdentifier: UITableViewCell.newMessageTVCellIdentifier)
        self.tableView.rowHeight = 80
        
        self.setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        self.searchController.searchBar.showsCancelButton = false
        self.navigationItem.searchController = searchController
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Type a username"
        self.definesPresentationContext = false
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .white
            textfield.backgroundColor = .themeLightBlack
        }
    }
}

// MARK: - UITableViewDataSource
extension NewConversationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inSearchMode ? self.filteredUsers.count : self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.newMessageTVCellIdentifier, for: indexPath) as! NewConversationTableViewCell
        
        let user = self.inSearchMode ? self.filteredUsers[indexPath.row] : self.users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.inSearchMode ? self.filteredUsers[indexPath.row] : self.users[indexPath.row]
        self.delegate?.controller(self, wantsToStartChatWith: user)
    }
}

extension NewConversationController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        self.filteredUsers = users.filter({ (user) -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        self.tableView.reloadData()
    }
}
