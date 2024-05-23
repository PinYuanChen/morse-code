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
    
    func test_init_doesNotConvert() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.convertCallCount, 0)
    }
    
    func test_validateInputCharacters() {
        let sut = makeSUT()
        
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
        let sut = makeSUT()
        let maxLength = MorseCodePresenter.maxInputLength
        let currentText = String(repeating: "z", count: maxLength) as NSString
        
        XCTAssertFalse(sut.validateInput(string: "z", currentText: currentText, range: .init(location: maxLength, length: 0)))
    }
    
    func test_convertInputTextToMorseCode() {
        let sut = makeSUT()
        
        sut.convertToMorseCode(text: "test1")
        XCTAssertEqual(sut.convertCallCount, 1)
        sut.convertToMorseCode(text: "test2")
        XCTAssertEqual(sut.convertCallCount, 2)
    }
    
    func test_convertFunction_OverrideFormerInput() {
        let sut = makeSUT()
        
        let firstInput = "First input"
        sut.convertToMorseCode(text: firstInput)
        XCTAssertEqual(sut.morseCodeString, firstInput)
        
        let secondInput = "Second input"
        sut.convertToMorseCode(text: secondInput)
        XCTAssertEqual(sut.morseCodeString, secondInput)
    }
    
    func test_convertMorseCodeToFlashSignals() {
        let sut = makeSUT()
        
        sut.playOrPauseFlashSignals(text: "hello")
        XCTAssertEqual(sut.convertFlashCount, 1)
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Localizable"
        let bundle = Bundle(for: MorseCodePresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodePresenterSpy {
        let sut = MorseCodePresenterSpy()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
