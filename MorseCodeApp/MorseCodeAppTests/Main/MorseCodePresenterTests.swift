//
//  MorseCodePresenterTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/15.
//

import XCTest
import XCTest
import MorseCode
import MorseCodeApp

public final class MorseCodePresenterTests: XCTestCase {
    
    func test_validateInputCharacters() {
        let (sut, _) = makeSUT()
        
        let validCharacter = "z"
        XCTAssertTrue(sut.validateInput(string: validCharacter))
        
        let validNumber = "0"
        XCTAssertTrue(sut.validateInput(string: validNumber))
        
        let validSign = "@"
        XCTAssertTrue(sut.validateInput(string: validSign))
        
        let invalidEmoji = "😎"
        XCTAssertFalse(sut.validateInput(string: invalidEmoji))
    }
    
    func test_validateInputLength() {
        let (sut, _) = makeSUT()
        let maxLength = MorseCodePresenter.maxInputLength
        let currentText = String(repeating: "z", count: maxLength) as NSString
        
        XCTAssertFalse(sut.validateInput(string: "z", currentText: currentText, range: .init(location: maxLength, length: 0)))
    }
    
    func test_convertToMorseCode() {
        let (sut, _) = makeSUT()
        
        let inputText = "SOS"
        sut.convertToMorseCode(text: inputText)
        XCTAssertEqual(sut.morseCodeString, sosMorseCodeString)
    }
    
    func test_convertFunction_OverrideFormerInput() {
        let (sut, _) = makeSUT()
        
        let firstInput = "SOS"
        sut.convertToMorseCode(text: firstInput)
        
        let secondInput = "a123"
        sut.convertToMorseCode(text: secondInput)
        XCTAssertEqual(sut.morseCodeString, a123MorseCodeString)
    }
    
    func test_saveMorseCode() async throws {
        let (sut, loader) = makeSUT()
        
        try await sut.saveToLocalStore(text: "SOS", morseCode: sosMorseCodeString)
        XCTAssertEqual(loader.receivedMessages, [.load, .save])
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Localizable"
        let bundle = Bundle(for: MorseCodePresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: MorseCodePresenterSpy, loader: LoaderSpy) {
        
        let convertor = MorseCodeConvertor()
        let flashManager = FlashManager()
        let loaderSpy = LoaderSpy()
        
        let sut = MorseCodePresenterSpy(convertor: convertor, flashManager: flashManager, localLoader: loaderSpy)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        return (sut, loaderSpy)
    }
    
    private let sosMorseCodeString = "... --- ... "
    private let a123MorseCodeString = ".- .---- ..--- ...-- "
    private let helloWorldMorseCodeString = ".... . .-.. .-.. ---    .-- --- .-. .-.. -.. -.-.-- "
}
