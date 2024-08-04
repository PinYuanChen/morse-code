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
    func updateFlashButton(status: FlashStatusType, enable: Bool)
}

public protocol MorseCodePresenterPrototype {
    /// Should weakify delegate
    var delegate: MorseCodePresenterDelegate? { get set }
    var presentedUUID: UUID? { get }
    func checkFirstTime()
    func convertToMorseCode(text: String) -> String
    func validateInput(string: String, currentText: NSString?, range: NSRange) -> Bool
    func saveToLocalStore(newRecord: MorseRecord)
    func getFlashButtonStatus()
    func playOrPauseFlashSignals(text: String)
}

public class MorseCodePresenter: MorseCodePresenterPrototype {
    
    public static let maxInputLength = 30
    
    public var delegate: MorseCodePresenterDelegate?
    public let convertor: MorseCodeConvertorPrototype
    public var flashManager: FlashManagerPrototype
    public let localLoader: MorseRecordLoaderPrototype
    public var presentedUUID: UUID?
    
    public required init(convertor: MorseCodeConvertorPrototype, flashManager: FlashManagerPrototype,
                         localLoader: MorseRecordLoaderPrototype) {
        self.convertor = convertor
        self.flashManager = flashManager
        self.localLoader = localLoader
        
        self.flashManager.completePlayingHandlers.append({ [unowned self] in
            self.delegate?.updateFlashButton(status: .stop, enable: self.presentedUUID != nil)
        })
    }
    
    public func checkFirstTime() {
        guard let _ = UserDefaults.standard.value(forKey: "HaveCheckedFirstTime") else {
            if !flashManager.enableTorch {
                delegate?.showError(title: nil, message: MorseCodePresenter.torchAlertMessage)
            }
            UserDefaults.standard.setValue(true, forKey: "HaveCheckedFirstTime")
            return
        }
    }
    
    public func convertToMorseCode(text: String) -> String {
        return convertor.convertToMorseCode(input: text)
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
    
    public func saveToLocalStore(newRecord: MorseRecord) {
        presentedUUID = newRecord.id
        
        localLoader.load { [weak self] loadResult in
            guard let self = self else { return }
            
            switch loadResult {
            case .success(let records):
                var newRecords = records ?? []
                newRecords.insert(newRecord, at: 0)
                self.localLoader.save(newRecords) { [weak self] saveResult in
                    if case .failure(_) = saveResult {
                        self?.delegate?.showError(title: MorseCodePresenter.alertTitle, message: MorseCodePresenter.saveErrorMessage)
                    }
                }
            case .failure(_):
                self.delegate?.showError(title: MorseCodePresenter.alertTitle, message: MorseCodePresenter.saveErrorMessage)
            }
        }
    }
    
    public func getFlashButtonStatus() {
        let (status, enable) = getFlashButtonStatus()
        delegate?.updateFlashButton(status: status, enable: enable)
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
    
    public func playOrPauseFlashSignals(text: String) {
        
        guard flashManager.enableTorch else {
            delegate?.showError(title: nil, message: MorseCodePresenter.torchAlertMessage)
            return
        }
        
        guard let presentedUUID = presentedUUID else {
            delegate?.updateFlashButton(status: FlashStatusType.stop, enable: false)
            return
        }
        
        let flashStatus: FlashStatusType
        var enable = true
        
        switch flashManager.currentStatus {
        case .stop:
            let signals = convertor.convertToMorseFlashSignals(input: text)
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

        delegate?.updateFlashButton(status: flashStatus, enable: enable)
    }
}

// MARK: - Localization
public extension MorseCodePresenter {
    static let title = NSLocalizedString("MORSE_FLASH_TITLE", comment: "Main page title")
    
    static let convertButtonTitle = NSLocalizedString("CONVERT", comment: "convert button")
    
    static let inputTextPlaceholder = NSLocalizedString("INPUT_PLACEHOLDER", comment: "user input textfield")
    
    static let morseCodePlaceholder = NSLocalizedString("MORSE_CODE_OUTPUT", comment: "morse code textfield")
    
    static let torchAlertMessage = NSLocalizedString("TORCH_ALERT_MESSAGE", comment: "torch is not open")
    
    static let alertConfirmTitle = NSLocalizedString("CONFIRM", comment: "confirm button title")
    
    static let alertTitle = NSLocalizedString("ALERT_TITLE", comment: "alert title in main page")
    
    static let saveErrorMessage = NSLocalizedString("SAVE_ERROR_MESSAGE", comment: "fail to save records")
}
