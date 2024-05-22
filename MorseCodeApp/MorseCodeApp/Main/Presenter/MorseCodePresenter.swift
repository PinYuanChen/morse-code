//
//  MorseCodePresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/15.
//

import Foundation
import MorseCode

public class MorseCodePresenter: MorseCodePresenterPrototype {
    
    public static let maxInputLength = 30
    
    public weak var delegate: MorseCodePresenterDelegate?
    
    public required init(convertor: MorseCodeConvertorPrototype, flashManager: FlashManagerPrototype,
                         localLoader: MorseRecordLoaderPrototype) {
        self.convertor = convertor
        self.flashManager = flashManager
        self.localLoader = localLoader
        
        self.flashManager.didFinishPlaying = { [unowned self] in
            self.delegate?.updateFlashButton(imageName: FlashStatusType.stop.imageName)
        }
    }
    
    public func convertToMorseCode(text: String) {
        let result =  convertor.convertToMorseCode(input: text)
        delegate?.displayMorseCode(code: result)
        saveToLocalStore(text: text, morseCode: result)
    }
    
    public func playOrPauseFlashSignals(text: String) {
        if flashManager.currentStatus == .stop {
            let signals = convertor.convertToMorseFlashSignals(input: text)
            flashManager.startPlaySignals(signals: signals)
        } else {
            flashManager.stopPlayingSignals()
        }

        delegate?.updateFlashButton(imageName: flashManager.currentStatus.imageName)
    }
    
    private func saveToLocalStore(text: String, morseCode: String) {
        let newRecord = MorseRecord(id: UUID(), text: text, morseCode: morseCode)
        
        localLoader.load { [weak self] result in
            switch result {
            case let .success(records):
                var records = records ?? []
                records.append(newRecord)
                self?.localLoader.save(records, completion: { _ in })
            default:
                break
            }
        }
    }
    
    // MARK: Private properties
    private let convertor: MorseCodeConvertorPrototype
    private var flashManager: FlashManagerPrototype
    private let localLoader: MorseRecordLoaderPrototype
}

// MARK: - Localization
extension MorseCodePresenter {
    static let title = NSLocalizedString("MORSE_FLASH_TITLE", comment: "Main page title")
    
    static let convertButtonTitle = NSLocalizedString("CONVERT", comment: "convert button")
    
    static let inputTextPlaceholder = NSLocalizedString("INPUT_PLACEHOLDER", comment: "user input textfield")
    
    static let morseCodePlaceholder = NSLocalizedString("MORSE_CODE_OUTPUT", comment: "morse code textfield")
}
