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
        let (_, convertor) = makeSUT()
        
        XCTAssertEqual(convertor.convertCallCount, 0)
    }
    
    func test_ValidateInputCharacter() {
        let (sut, _) = makeSUT()
        
        let validCharacter = "z"
        XCTAssertTrue(sut.validateInput(string: validCharacter, currentText: nil, range: .init()))
        
        let validNumber = "0"
        XCTAssertTrue(sut.validateInput(string: validNumber, currentText: nil, range: .init()))
        
        let validSign = "@"
        XCTAssertTrue(sut.validateInput(string: validSign, currentText: nil, range: .init()))
        
        let invalidEmoji = "😎"
        XCTAssertFalse(sut.validateInput(string: invalidEmoji, currentText: nil, range: .init()))
    }
    
    func test_ValidateInputLength() {
        let (sut, _) = makeSUT()
        let maxLength = MorseCodePresenter.maxInputLength
        let currentText = String(repeating: "z", count: maxLength) as NSString
        
        XCTAssertFalse(sut.validateInput(string: "z", currentText: currentText, range: .init(location: maxLength, length: 0)))
    }
    
    func test_convertInputTextToMorseCode() {
        let (sut, convertor) = makeSUT()
        
        sut.convertToMorseCode(text: "test1")
        XCTAssertEqual(convertor.convertCallCount, 1)
        sut.convertToMorseCode(text: "test2")
        XCTAssertEqual(convertor.convertCallCount, 2)
    }
    
    func test_convertFunction_OverrideFormerInput() {
        let (sut, convertor) = makeSUT()
        
        let firstInput = "First input"
        sut.convertToMorseCode(text: firstInput)
        XCTAssertEqual(convertor.morseCodeString, firstInput)
        
        let secondInput = "Second input"
        sut.convertToMorseCode(text: secondInput)
        XCTAssertEqual(convertor.morseCodeString, secondInput)
    }
    
    func test_convertMorseCodeToFlashSignals() {
        let (sut, convertor) = makeSUT()
        
        sut.playOrPauseFlashSignals(text: "hello")
        XCTAssertEqual(convertor.convertFlashCount, 1)
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Localizable"
        let bundle = Bundle(for: MorseCodePresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: MorseCodePresenter, convertor: ConvertorSpy) {
        let convertor = ConvertorSpy()
        let sut = MorseCodePresenter(convertor: convertor, flashManager: FlashManager())
        trackForMemoryLeaks(convertor, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, convertor)
    }
}
