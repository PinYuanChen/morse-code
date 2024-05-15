//
//  MorseCodePresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/15.
//

import Foundation
import MorseCode

public class MorseCodePresenter {
    
    public required init(convertor: MorseCodeConvertorPrototype, flashManager: FlashManagerPrototype) {
        self.convertor = convertor
        self.flashManager = flashManager
    }
    
    // MARK: Private properties
    private let convertor: MorseCodeConvertorPrototype
    private var flashManager: FlashManagerPrototype
}
