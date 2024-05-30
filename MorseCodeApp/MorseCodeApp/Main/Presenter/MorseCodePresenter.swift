//
//  MorseCodePresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/15.
//

import Foundation
import MorseCode

public protocol MorseCodePresenterDelegate: AnyObject {
    func showError(title: String, message: String)
    func updateFlashButton(imageName: String)
}

public class MorseCodePresenter: MorseCodeConvertorPrototype {
    
    public static let maxInputLength = 30
    
    public weak var delegate: MorseCodePresenterDelegate?
    public var flashManager: FlashManagerPrototype
    public let localLoader: MorseRecordLoaderPrototype
    
    public required init(flashManager: FlashManagerPrototype,
                         localLoader: MorseRecordLoaderPrototype) {
        self.flashManager = flashManager
        self.localLoader = localLoader
        
        self.flashManager.didFinishPlaying = { [unowned self] in
            self.delegate?.updateFlashButton(imageName: FlashStatusType.stop.imageName)
        }
    }
    
    public func convertToMorseCode(text: String) -> String {
        return convertToMorseCode(input: text)
    }
    
    public func validateInput(string: String, currentText: NSString? = nil, range: NSRange = .init()) -> Bool {
        let regex = "[A-Za-z0-9 .,?!-/@()]*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        guard predicate.evaluate(with: string) else {
            return false
        }
        
        let newString = currentText?.replacingCharacters(in: range, with: string)
        let length = newString?.count ?? 0
        return length <= MorseCodePresenter.maxInputLength
    }
    
    public func saveToLocalStore(newRecord: MorseRecord) async throws {
        var records = try await localLoader.load() ?? []
        records.append(newRecord)
        try await localLoader.save(records)
    }
    
    public func playOrPauseFlashSignals(text: String) {
        
        if flashManager.currentStatus == .stop {
            let signals = convertToMorseFlashSignals(input: text)
            flashManager.startPlaySignals(signals: signals, torchEnable: {
                let enable = FlashManager.enableTorch()
                if !enable {
                    delegate?.showError(title: MorseCodePresenter.torchAlertTitle, message: MorseCodePresenter.torchAlertMessage)
                }
                return enable
            })
        } else {
            flashManager.stopPlayingSignals()
        }

        delegate?.updateFlashButton(imageName: flashManager.currentStatus.imageName)
    }
}

// MARK: - Localization
extension MorseCodePresenter {
    static let title = NSLocalizedString("MORSE_FLASH_TITLE", comment: "Main page title")
    
    static let convertButtonTitle = NSLocalizedString("CONVERT", comment: "convert button")
    
    static let inputTextPlaceholder = NSLocalizedString("INPUT_PLACEHOLDER", comment: "user input textfield")
    
    static let morseCodePlaceholder = NSLocalizedString("MORSE_CODE_OUTPUT", comment: "morse code textfield")
    
    static let torchAlertTitle = NSLocalizedString("TORCH_ALERT_TITLE", comment: "torch is not open")
    
    static let torchAlertMessage = NSLocalizedString("TORCH_ALERT_MESSAGE", comment: "torch is not open")
    
    static let alertConfirmTitle = NSLocalizedString("CONFIRM", comment: "confirm button title")
}
