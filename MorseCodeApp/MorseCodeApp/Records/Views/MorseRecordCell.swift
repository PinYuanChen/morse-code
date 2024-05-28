//
//  MorseRecordCell.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/28.
//

import UIKit

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
        setupContentView()
    }
    
    func setupContentView() {
        
    }
    
    func setupTitleLabel() {
        
    }
    
    func setupMorseLabel() {
        
    }
    
    func setupFlashButton() {
        
    }
    
    func setupDeleteButton() {
        
    }
}

