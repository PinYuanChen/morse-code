//
//  MorseCodePresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/15.
//

import Foundation
import MorseCode

public protocol MorseCodePresenterDelegate: AnyObject {
    func displayMorseCode(code: String)
    func updateFlashButton(status: FlashStatusType)
}

public class MorseCodePresenter {
    
    static let title = NSLocalizedString("MORSE_FLASH_TITLE", comment: "Main page title")
    
    static let convertButtonTitle = NSLocalizedString("CONVERT", comment: "convert button")
    
    static let inputTextPlaceholder = NSLocalizedString("INPUT_PLACEHOLDER", comment: "user input textfield")
    
    static let morseCodePlaceholder = NSLocalizedString("MORSE_CODE_OUTPUT", comment: "morse code textfield")
    
    public weak var delegate: MorseCodePresenterDelegate?
    
    public required init(convertor: MorseCodeConvertorPrototype, flashManager: FlashManagerPrototype) {
        self.convertor = convertor
        self.flashManager = flashManager
        
        self.flashManager.didFinishPlaying = { [unowned self] in
            self.delegate?.updateFlashButton(status: .stop)
        }
    }
    
    public func validateInput(string: String) -> Bool {
        let regex = "[A-Za-z0-9 .,?!-/@()]*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: string)
    }
    
    public func convertToMorseCode(text: String) {
        let result =  convertor.convertToMorseCode(input: text)
        delegate?.displayMorseCode(code: result)
    }
    
    public func playOrPauseFlashSignals(text: String) {
        if flashManager.currentStatus == .stop {
            let signals = convertor.convertToMorseFlashSignals(input: text)
            flashManager.startPlaySignals(signals: signals)
        } else {
            flashManager.stopPlayingSignals()
        }

        delegate?.updateFlashButton(status: flashManager.currentStatus)
    }
    
    // MARK: Private properties
    private let convertor: MorseCodeConvertorPrototype
    private var flashManager: FlashManagerPrototype
}