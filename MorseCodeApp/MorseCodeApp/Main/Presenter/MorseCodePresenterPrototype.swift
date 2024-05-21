//
//  MorseCodePresenterPrototype.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/21.
//

import Foundation

public protocol MorseCodePresenterDelegate: AnyObject {
    func displayMorseCode(code: String)
    func updateFlashButton(imageName: String)
}

public protocol MorseCodePresenterPrototype {
    func validateInput(string: String, currentText: NSString?, range: NSRange) -> Bool
    func convertToMorseCode(text: String)
    func playOrPauseFlashSignals(text: String)
}

extension MorseCodePresenterPrototype {
    public func validateInput(string: String, currentText: NSString?, range: NSRange) -> Bool {
        let regex = "[A-Za-z0-9 .,?!-/@()]*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        guard predicate.evaluate(with: string) else {
            return false
        }
        
        let newString = currentText?.replacingCharacters(in: range, with: string)
        let length = newString?.count ?? 0
        return length <= MorseCodePresenter.maxInputLength
    }
}
