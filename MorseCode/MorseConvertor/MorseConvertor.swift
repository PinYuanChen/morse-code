//
//  MorseConvertor.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/7/25.
//

import Foundation

public extension MorseCodeConvertorPrototype {
    func convertToMorseCode(input: String) -> String {
        
        var output = ""
        let shortPauseSpace = " "
        let longPauseSpace = "   "
        
        for char in input.lowercased() {
            guard let mCode = morseCodeDict["\(char)"] else {
                continue
            }
            
            // Replace space between words
            if mCode == " " {
                output.append(longPauseSpace)
            } else {
                output.append(mCode)
                output.append(shortPauseSpace)
            }
        }
        
        return output
    }
    
    func convertToMorseFlashSignals(input: String) -> [FlashType] {
        
        var signals = [FlashType]()
        for char in input {
            guard let type = FlashType(rawValue: "\(char)") else { continue }
            
            if type == .pause {
                let longPause = [FlashType](repeating: .pause, count: 2)
                signals.append(contentsOf: longPause)
            } else {
                signals.append(type)
                signals.append(.pause) // pause between characters
            }
        }
        
        return signals
    }
}
