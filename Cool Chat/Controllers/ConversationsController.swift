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
    
    private func setupUI(){
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Messages"
        
        self.view.addSubview(self.tableView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.createProfileButton(target: self, selector: #selector(showProfileDidTap))
    }
}
