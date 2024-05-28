//
// Created on 2023/12/27.
//

import MorseCode
import MorseCodeApp

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
    
    func saveToLocalStore(text: String, morseCode: String) async throws {
        do {
            let _ = try await localLoader.load()
            try await localLoader.save([])
        } catch {
            throw error
        }
    }
}
