//
//  MorseCodePresenterTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/15.
//

import XCTest
import MorseCode
import MorseCodeApp

public final class MorseCodePresenterTests: XCTestCase {
    
    func test_validateValidCharacters() {
        let sut = makeSUT()
        
        let valids = ["z", "0", "@"]

        valids.forEach {
            XCTAssertTrue(sut.validateInput(string: $0))
        }
    }
    
    func test_validateInvalidCharacters() {
        let sut = makeSUT()
        
        let invalids = ["😎", "🥩", "卍", "中"]
        invalids.forEach {
            XCTAssertFalse(sut.validateInput(string: $0))
        }
        
    }
    
    func test_validateInputLength() {
        let sut = makeSUT()
        let maxLength = MorseCodePresenter.maxInputLength
        let currentText = String(repeating: "z", count: maxLength) as NSString
        
        XCTAssertFalse(sut.validateInput(string: "z", currentText: currentText, range: .init(location: maxLength, length: 0)))
    }
    
    func test_convertValidInputIntoMorseCode() {
        let sut = makeSUT()
        XCTAssertEqual(sut.convertToMorseCode(text: "sos"), sosMorseCodeString)
        XCTAssertEqual(sut.convertToMorseCode(text: "a123"), a123MorseCodeString)
        XCTAssertEqual(sut.convertToMorseCode(text: "Hello world!"), helloWorldMorseCodeString)
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Localizable"
        let bundle = Bundle(for: MorseCodePresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
    func test_presentedUUID_isSetAfterSaveToLocalStore() {
        let sut = makeSUT()
        XCTAssertNil(sut.presentedUUID)
        let newRecord = anyRecord()
        sut.saveToLocalStore(newRecord: newRecord)
        XCTAssertEqual(newRecord.id, sut.presentedUUID)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) ->  MorseCodePresenter {
        
        let sut = MorseCodePresenter(convertor: MorseConvertor(), flashManager: FlashManager(), localLoader: LoaderSpy())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private let sosMorseCodeString = "... --- ... "
    private let a123MorseCodeString = ".- .---- ..--- ...-- "
    private let helloWorldMorseCodeString = ".... . .-.. .-.. ---    .-- --- .-. .-.. -.. -.-.-- "
}
