//
// Created on 2023/12/22.
//

import Foundation

public protocol MorseCodeConvertorPrototype {
    func convertToMorseCode(input: String) -> String
    func convertToMorseFlashSignals(input: String) -> [FlashType]
}
