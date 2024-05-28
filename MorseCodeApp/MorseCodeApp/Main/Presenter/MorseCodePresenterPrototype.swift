//
//  MorseCodePresenterPrototype.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/21.
//

import Foundation
import MorseCode

public protocol MorseCodePresenterDelegate: AnyObject {
    func displayMorseCode(code: String)
    func updateFlashButton(imageName: String)
}

public protocol MorseCodePresenterPrototype {
    var delegate: MorseCodePresenterDelegate? { get set }
    var convertor: MorseCodeConvertorPrototype { get }
    var flashManager: FlashManagerPrototype { get }
    var localLoader: MorseRecordLoaderPrototype { get }
    func validateInput(string: String, currentText: NSString?, range: NSRange) -> Bool
    func convertToMorseCode(text: String)
    func saveToLocalStore(text: String, morseCode: String) async throws
    func playOrPauseFlashSignals(text: String)
}

extension MorseCodePresenterPrototype {
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
    
    public func playOrPauseFlashSignals(text: String) {
        if flashManager.currentStatus == .stop {
            let signals = convertor.convertToMorseFlashSignals(input: text)
            flashManager.startPlaySignals(signals: signals)
        } else {
            flashManager.stopPlayingSignals()
        }

        delegate?.updateFlashButton(imageName: flashManager.currentStatus.imageName)
    }
}
