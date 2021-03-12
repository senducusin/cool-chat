//
//  ConversationsController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

class ConversationsController: UIViewController {
    // MARK: - Properties
    let tableView = UITableView.createTable()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Selectors
    @objc private func showProfileDidTap(){
        print("tapped!")
    }
    
    // MARK: - Helpers
    
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
