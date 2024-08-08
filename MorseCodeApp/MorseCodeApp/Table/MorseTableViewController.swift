//
//  MorseTableViewController.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/8/4.
//

import UIKit
import MorseCode

public class MorseTableViewController: UIViewController {
    
    public let titleLabel = UILabel()
    
    public required init(dataSource: [String]) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private let dataSource: [String]
    private let tableView = UITableView()
    private lazy var tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 60
}

private extension MorseTableViewController {
    func setupUI() {
        view.backgroundColor = .bg04121F
        setupTitleLabel()
        setupTableView()
    }
    
    func setupTitleLabel() {
        titleLabel.text = Localization.string("MORSE_LOOKUP_TABLE", comment: "")
        titleLabel.textColor = .txt5BC5A5
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTableView() {
        tableView.register(MorseTableViewCell.self)
        tableView.dataSource = self
        tableView.backgroundColor = .bg25333F
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = .zero
        tableView.layer.cornerRadius = 10
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-(tabBarHeight+10))
        }
    }
}

extension MorseTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MorseTableViewCell.use(table: tableView, for: indexPath)
        let title = dataSource[indexPath.row]
        let morseCode = morseCodeDict[title] ?? ""
        
        cell.configure(title: title, morse: morseCode)
        return cell
    }
}
