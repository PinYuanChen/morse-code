//
// Created on 2023/12/27.
//

import MorseCode
import MorseCodeApp

final class MorseCodePresenterSpy: MorseCodePresenterPrototype {
    
    public var convertCallCount = 0
    public var convertFlashCount = 0
    public var morseCodeString = ""
    
    func convertToMorseCode(text: String) {
        convertCallCount += 1
        morseCodeString = text
    }
    
    func playOrPauseFlashSignals(text: String) {
        convertFlashCount += 1
    }
}
