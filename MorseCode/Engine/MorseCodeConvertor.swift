//
// Created on 2023/12/22.
//

import Foundation

public class MorseCodeConvertor {
    
    public init() { }
    
    public enum FlashType: String {
        case dah = "-"
        case di = "."
        case pause = " "
        
        var duration: Double {
            switch self {
            case .dah:
                return 3.0
            case .di, .pause:
                return 1.0
            }
        }
    }
    
    public func convertToMorseCode(input: String) -> String {
        
        var output = ""
        for char in input.lowercased() {
            guard let mCode = morseCodeDict["\(char)"] else {
                continue
            }
            if mCode == " " {
                output.append("   ")
            } else {
                output.append(mCode)
                output.append(" ")
            }
        }
        
        return output
    }
    
    public func convertToMorseFlashSignals(input: String) -> [FlashType] {
        
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
