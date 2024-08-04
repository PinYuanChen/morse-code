//
//  MorseTableViewCell.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/8/4.
//

import UIKit
import SnapKit

class MorseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, morse: String) {
        titleLabel.text = title
        morseLabel.text = morse
    }
    
    private let titleLabel = UILabel()
    private let morseLabel = UILabel()
}

private extension MorseTableViewCell {
    func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupTitleLabel()
        setupMorseLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = .white.withAlphaComponent(0.7)
        titleLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(17)
        }
    }
    
    func setupMorseLabel() {
        morseLabel.textColor = .txt5BC5A5
        morseLabel.textAlignment = .right
        morseLabel.font = .monospacedSystemFont(ofSize: 17, weight: .medium)
        contentView.addSubview(morseLabel)
        
        morseLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(25)
            $0.centerY.equalTo(titleLabel)
        }
    }
}
