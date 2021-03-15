//
//  ProfileController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import UIKit
import Firebase

class ProfileController: UITableViewController {
    
    // MARK: - Properties
    private var user: User? {
        didSet { headerView.user = self.user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(
                                                    x: 0, y: 0, width: self.view.frame.width, height: 380)
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.delegate = self
        self.setupUI()
        self.fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    private func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseWebService.fetchUser(with: uid) { (user) in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.tableView.backgroundColor = .white
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: UITableViewCell.profileTVCellIdentifier)
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.rowHeight = 64
        self.tableView.backgroundColor = .systemGroupedBackground
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.profileTVCellIdentifier, for: indexPath) as! ProfileTableViewCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}
