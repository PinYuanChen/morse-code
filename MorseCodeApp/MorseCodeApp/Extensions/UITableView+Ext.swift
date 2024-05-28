//
//  UITableView+Ext.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/28.
//

import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass...) {
        cellClass.forEach {
            self.register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
}

extension UITableViewCell {
    static func use(table view: UITableView, for index: IndexPath) -> Self {
        return cell(tableView: view, for: index)
    }

    private static func cell(tableView: UITableView, for index: IndexPath) -> Self {

        let id = String(describing: self)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: index) as? Self else {
            assert(false)
            return .init()
        }

        return cell
    }
}

