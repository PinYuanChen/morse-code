//
//  RecordsViewController.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import UIKit
import SnapKit
import MorseCode

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
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    public func showError(title: String?, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: MorseCodePresenter.alertConfirmTitle, style: .cancel)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: false)
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
        
        cell.updateButtons(status: presenter.currentFlashStatus, recordId: record.id)
        
        cell.playAction = { [unowned self] in
            self.presenter.playOrPauseFlash(at: indexPath.row)
        }
        
        cell.deleteAction = { [weak self] in
            Task.init {
                try await self?.presenter.deleteRecord(at: indexPath.row)
            }
        }
        
        return cell
    }
}
