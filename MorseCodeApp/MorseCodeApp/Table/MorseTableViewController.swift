//
//  MorseTableViewController.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/8/4.
//

import UIKit
import MorseCode

public class MorseTableViewController: UIViewController {
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private let alphabets = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0 )}
    private let numbers = Array(0...9).map { String($0 )}
    private let signs = [".", ",", "?", "!", "-", "/", "@", "(", ")"]
    private lazy var dataSource = alphabets + numbers + signs
    private let tableView = UITableView()
}

private extension MorseTableViewController {
    func setupUI() {
        view.backgroundColor = .bg04121F
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MorseTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        .init()
    }
}
