//
//  ProfileController.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import UIKit
import Firebase

protocol ProfileControllerDelegate: class {
    func handleLogoutCurrentUser()
}

class ProfileController: UITableViewController {
    
    // MARK: - Properties
    private var user: User? {
        didSet { headerView.user = self.user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(
                                                    x: 0, y: 0, width: self.view.frame.width, height: 380)
    )
    
    private let footerView = ProfileFooter()
    
    weak var delegate: ProfileControllerDelegate?
    
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
        FirebaseWebService.shared.fetchUser(with: uid) { (user) in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    private func setupUI(){
        self.tableView.backgroundColor = .white
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: UITableViewCell.profileTVCellIdentifier)
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.rowHeight = 64
        self.tableView.backgroundColor = .systemGroupedBackground
        
        self.footerView.delegate = self
        self.footerView.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.tableView.tableFooterView = self.footerView
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        
        print(viewModel.description)
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileController: ProfileFooterDelegate{
    func handleLogoutCurrentUser() {
//        self.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.dismiss(animated: true) {
                self.delegate?.handleLogoutCurrentUser()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
