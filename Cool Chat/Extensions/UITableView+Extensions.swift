//
//  UITableView+Extensions.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/12/21.
//

import UIKit

extension UITableView {
    static public func createTable(customCellClass: AnyClass? = nil) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(
            customCellClass == nil ? UITableViewCell.self : customCellClass.self,
            forCellReuseIdentifier: UITableViewCell.conversationTVCellIdentifier)
        return tableView
    }
}
