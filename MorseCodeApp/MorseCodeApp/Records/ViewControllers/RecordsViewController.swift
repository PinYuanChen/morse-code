//
//  RecordsViewController.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import UIKit
import SnapKit

public class RecordsViewController: UIViewController {
    
    let presenter: RecordsPresenter
    
    public required init(presenter: RecordsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task.init {
            try await presenter.loadRecords()
        }
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

extension RecordsViewController: RecordsPresenterDelegate {
    public func reloadData() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    public func showError(title: String, message: String) {
        // TODO
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.records.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = presenter.records[indexPath.row]
        let cell = MorseRecordCell.use(table: tableView, for: indexPath)
        cell.configure(record)
        
        return cell
    }
}
