//
//  MorseRecordCell.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/28.
//

import UIKit
import SnapKit

class MorseRecordCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel()
    private let morseLabel = UILabel()
    private let flashButton = CustomButton()
    private let deleteButton = CustomButton()
}

// MARK: - Setup UI
private extension MorseRecordCell {
    func setupUI() {
        setupTitleLabel()
        setupMorseLabel()
        setupFlashButton()
        setupDeleteButton()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func setupMorseLabel() {
        morseLabel.textColor = .txt5BC5A5
        
        contentView.addSubview(morseLabel)
        morseLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.width.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setupFlashButton() {
        flashButton.setBackgroundImage(.init(systemName: "flashlight.on.circle.fill"), for: .normal)
        flashButton.tintColor = .white
        flashButton.layer.cornerRadius = 20
        flashButton.layer.masksToBounds = true
        
        contentView.addSubview(flashButton)
        flashButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupDeleteButton() {
        deleteButton.setBackgroundImage(.init(systemName: "trash.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.masksToBounds = true
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(flashButton.snp.trailing).offset(10)
            $0.size.centerY.equalTo(flashButton)
        }
    }
}

