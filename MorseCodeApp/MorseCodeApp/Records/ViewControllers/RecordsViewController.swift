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
    
    public let presenter: RecordsPresenterPrototype
    
    public required init(presenter: RecordsPresenterPrototype) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
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
        presenter.loadRecords()
    }
    
    private let emptyLabel = UILabel()
    private let tableView = UITableView()
}

private extension RecordsViewController {
    func setupUI() {
        view.backgroundColor = .bg04121F
        setupTableView()
        setupEmptyLabel()
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
    
    func setupEmptyLabel() {
        emptyLabel.text = NSLocalizedString("EMPTY_RECORD_MESSAGE", comment: "Records view controller")
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .bg275452
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-50)
        }
    }
}

extension RecordsViewController: RecordsPresenterDelegate {
    public func reloadData() {
        self.emptyLabel.isHidden = !self.presenter.records.isEmpty
        self.tableView.reloadData()
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
        
        cell.deleteAction = { [weak self] in self?.presenter.deleteRecord(at: indexPath.row)
        }
        
        return cell
    }
}
