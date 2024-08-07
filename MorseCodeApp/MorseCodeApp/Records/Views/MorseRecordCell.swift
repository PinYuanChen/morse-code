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
    
    var playAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playAction = nil
        deleteAction = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ record: MorseRecord) {
        titleLabel.text = record.text
        morseLabel.text = record.morseCode
    }
    
    func updateButtons(status: FlashStatusType, recordId: UUID) {
        
        if case .playing(let id) = status {
            if id == recordId {
                setFlashAndDeleteButton(status: status, flashEnable: true, deleteEnable: false)
            } else {
                setFlashAndDeleteButton(status: .stop, flashEnable: false, deleteEnable: false)
            }
        } else {
            setFlashAndDeleteButton(status: status, flashEnable: true, deleteEnable: true)
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
    
    func setupDeleteButton() {
        deleteButton.setBackgroundImage(.init(systemName: "trash.circle.fill"), for: .normal)
        deleteButton.tintColor = .white.withAlphaComponent(0.6)
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.masksToBounds = true
        deleteButton.addTarget(self, action: #selector(didTappedDeleteButton), for: .touchUpInside)
        
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
        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)
        
        contentView.addSubview(flashButton)
        flashButton.snp.makeConstraints {
            $0.size.centerY.equalTo(deleteButton)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-10)
        }
    }
}

private extension MorseRecordCell {
    @objc func didTappedFlashButton() {
        playAction?()
    }
    
    @objc func didTappedDeleteButton() {
        deleteAction?()
    }
    
    func setFlashAndDeleteButton(status: FlashStatusType, flashEnable: Bool, deleteEnable: Bool) {
        
        let imageName = switch status {
        case .playing(_): "flashlight.slash.circle.fill"
        case .stop:
            "flashlight.on.circle.fill"
        }
        
        flashButton.setBackgroundImage(.init(systemName: imageName), for: .normal)
        flashButton.isEnabled = flashEnable
        deleteButton.isEnabled = deleteEnable
    }
}
