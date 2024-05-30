//
//  MorseRecordCell.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/28.
//

import UIKit
import SnapKit
import MorseCode

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
    
    func configure(_ record: MorseRecord) {
        titleLabel.text = record.text
        morseLabel.text = record.morseCode
    }
    
    func updateButtons(isPlaying: Bool, isPlayingIndex: Bool) {
        if isPlayingIndex {
            flashButton.setBackgroundImage(.init(systemName: FlashStatusType.playing.imageName), for: .normal)
            deleteButton.isEnabled = false
        } else {
            flashButton.setBackgroundImage(.init(systemName: FlashStatusType.stop.imageName), for: .normal)
            flashButton.isEnabled = !isPlaying
            deleteButton.isEnabled = !isPlaying
        }
    }
    
    private let titleLabel = UILabel()
    private let morseLabel = UILabel()
    private let flashButton = CustomButton()
    private let deleteButton = CustomButton()
}

// MARK: - Setup UI
private extension MorseRecordCell {
    func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupTitleLabel()
        setupMorseLabel()
        setupDeleteButton()
        setupFlashButton()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = .white.withAlphaComponent(0.7)
        titleLabel.text = "Title"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func setupMorseLabel() {
        morseLabel.textColor = .txt5BC5A5
        morseLabel.text = "Morse Code"
        contentView.addSubview(morseLabel)
        morseLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.width.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setupDeleteButton() {
        deleteButton.setBackgroundImage(.init(systemName: "trash.circle.fill"), for: .normal)
        deleteButton.tintColor = .white.withAlphaComponent(0.6)
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.masksToBounds = true
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupFlashButton() {
        flashButton.setBackgroundImage(.init(systemName: "flashlight.on.circle.fill"), for: .normal)
        flashButton.tintColor = .white.withAlphaComponent(0.6)
        flashButton.layer.cornerRadius = 20
        flashButton.layer.masksToBounds = true
        
        contentView.addSubview(flashButton)
        flashButton.snp.makeConstraints {
            $0.size.centerY.equalTo(deleteButton)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-10)
        }
    }
}

