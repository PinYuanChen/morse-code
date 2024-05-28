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
    public let convertor: MorseCodeConvertorPrototype
    public var flashManager: FlashManagerPrototype
    public let localLoader: MorseRecordLoaderPrototype
    
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
        
        Task.init {
            do {
                try await saveToLocalStore(text: text, morseCode: result)
            } catch {
                print(error)
            }
        }
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
    
    private func saveToLocalStore(text: String, morseCode: String) async throws {
        let newRecord = MorseRecord(id: UUID(), text: text, morseCode: morseCode)
        
        var records = try await localLoader.load() ?? []
        records.append(newRecord)
        try await localLoader.save(records)
    }
    
}

// MARK: - Localization
extension MorseCodePresenter {
    static let title = NSLocalizedString("MORSE_FLASH_TITLE", comment: "Main page title")
    
    static let convertButtonTitle = NSLocalizedString("CONVERT", comment: "convert button")
    
    static let inputTextPlaceholder = NSLocalizedString("INPUT_PLACEHOLDER", comment: "user input textfield")
    
    static let morseCodePlaceholder = NSLocalizedString("MORSE_CODE_OUTPUT", comment: "morse code textfield")
}
