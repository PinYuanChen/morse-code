//
//  RecordsViewController.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import UIKit
import SnapKit

public class RecordsViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private let tableView = UITableView()
}

private extension RecordsViewController {
    func setupUI() {
        view.backgroundColor = .bg04121F
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(MorseRecordCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MorseRecordCell.use(table: tableView, for: indexPath)
        return cell
    }
}
