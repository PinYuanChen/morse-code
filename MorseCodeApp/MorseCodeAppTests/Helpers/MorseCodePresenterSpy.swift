//
// Created on 2023/12/27.
//

import MorseCode
import MorseCodeApp

class LoaderSpy: MorseRecordLoaderPrototype {
    
    var loadCount = 0
    var saveCount = 0
    
    func save(_ records: [MorseRecord]) async throws {
        saveCount += 1
    }
    
    func load() async throws -> [MorseRecord]? {
        loadCount += 1
        return []
    }
}

final class MorseCodePresenterSpy: MorseCodePresenterPrototype {
    
    let convertor: MorseCodeConvertorPrototype
    let flashManager: FlashManagerPrototype
    let localLoader: MorseRecordLoaderPrototype
    var delegate: MorseCodePresenterDelegate?
    
    var morseCodeString = ""
    
    init(convertor: MorseCodeConvertorPrototype,
         flashManager: FlashManagerPrototype,
         localLoader: MorseRecordLoaderPrototype,
         delegate: MorseCodePresenterDelegate? = nil) {
        self.convertor = convertor
        self.flashManager = flashManager
        self.localLoader = localLoader
        self.delegate = delegate
    }
    
    func convertToMorseCode(text: String) {
        morseCodeString = convertor.convertToMorseCode(input: text)
    }
    
    func playOrPauseFlashSignals(text: String) {
        
    }
}
