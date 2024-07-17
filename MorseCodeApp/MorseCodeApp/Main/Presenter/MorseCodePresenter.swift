//
//  MorseCodePresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/15.
//

import Foundation
import MorseCode

public protocol MorseCodePresenterDelegate: AnyObject {
    func showError(title: String?, message: String)
    func updateFlashButton(imageName: String, enable: Bool)
}

public class MorseCodePresenter: MorseCodeConvertorPrototype {
    
    public static let maxInputLength = 30
    
    public weak var delegate: MorseCodePresenterDelegate?
    public var flashManager: FlashManagerPrototype
    public let localLoader: MorseRecordLoaderPrototype
    public var presentedUUID: UUID?
    
    public required init(flashManager: FlashManagerPrototype,
                         localLoader: MorseRecordLoaderPrototype) {
        self.flashManager = flashManager
        self.localLoader = localLoader
        
        self.flashManager.didFinishPlaying = { [unowned self] in
            self.delegate?.updateFlashButton(imageName: FlashStatusType.stop.imageName, enable: self.presentedUUID != nil)
        }
    }
    
    public func checkFirstTime() {
        guard let _ = UserDefaults.standard.value(forKey: "HaveCheckedFirstTime") else {
            if !FlashManager.enableTorch() {
                delegate?.showError(title: nil, message: MorseCodePresenter.torchAlertMessage)
            }
            UserDefaults.standard.setValue(true, forKey: "HaveCheckedFirstTime")
            return
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
        presentedUUID = newRecord.id
        
        var records = try await localLoader.load() ?? []
        records.append(newRecord)
        try await localLoader.save(records)
    }
    
    public func getFlashButtonStatus() {
        let (status, enable) = getFlashButtonStatus()
        delegate?.updateFlashButton(imageName: status.imageName, enable: enable)
    }
    
    private func getFlashButtonStatus() -> (status: FlashStatusType, enable: Bool) {
        guard let presentedUUID = presentedUUID else {
            return (status: .stop, enable: false)
        }
        
        if case let .playing(id: uuid) = flashManager.currentStatus {
            if uuid == presentedUUID {
                return (status: .playing(id: uuid), enable: true)
            } else {
                return (status: .stop, enable: false)
            }
        } else {
            return (status: .stop, enable: true)
        }
    }
    
    public func playOrPauseFlashSignals(text: String, enableTorch: (() -> Bool) = FlashManager.enableTorch) {
        
        guard enableTorch() == true else {
            delegate?.showError(title: nil, message: MorseCodePresenter.torchAlertMessage)
            return
        }
        
        guard let presentedUUID = presentedUUID else {
            delegate?.updateFlashButton(imageName: FlashStatusType.stop.imageName, enable: false)
            return
        }
        
        let flashStatus: FlashStatusType
        var enable = true
        
        switch flashManager.currentStatus {
        case .stop:
            let signals = convertToMorseFlashSignals(input: text)
            flashManager.startPlaySignals(signals: signals, uuid: presentedUUID)
            flashStatus = .playing(id: presentedUUID)
        case let .playing(id: uuid):
            flashStatus = .stop
            if uuid == presentedUUID {
                flashManager.stopPlayingSignals()
            } else {
                enable = false
            }
        }

        delegate?.updateFlashButton(imageName: flashStatus.imageName, enable: enable)
    }
}

// MARK: - Localization
extension MorseCodePresenter {
    static let title = NSLocalizedString("MORSE_FLASH_TITLE", comment: "Main page title")
    
    static let convertButtonTitle = NSLocalizedString("CONVERT", comment: "convert button")
    
    static let inputTextPlaceholder = NSLocalizedString("INPUT_PLACEHOLDER", comment: "user input textfield")
    
    static let morseCodePlaceholder = NSLocalizedString("MORSE_CODE_OUTPUT", comment: "morse code textfield")
    
    static let torchAlertMessage = NSLocalizedString("TORCH_ALERT_MESSAGE", comment: "torch is not open")
    
    static let alertConfirmTitle = NSLocalizedString("CONFIRM", comment: "confirm button title")
}
