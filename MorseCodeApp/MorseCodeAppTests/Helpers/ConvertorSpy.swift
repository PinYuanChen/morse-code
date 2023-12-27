//
// Created on 2023/12/27.
//

import MorseCode

final class ConvertorSpy: MorseCodeConvertorPrototype {
    
    var convertCallCount = 0
    var flashCallCount = 0
    var morseCodeString = ""
    
    func convertToMorseCode(input: String) -> String {
        convertCallCount += 1
        morseCodeString = input
        return input
    }
    
    func convertToMorseFlashSignals(input: String) -> [MorseCode.FlashType] {
        flashCallCount += 1
        return fakeSignals
    }
    
    private let fakeSignals: [MorseCode.FlashType] = [.di, .pause, .dah, .pause]
}
