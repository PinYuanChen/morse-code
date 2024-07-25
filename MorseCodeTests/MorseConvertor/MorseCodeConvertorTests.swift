//
//  MorseCodeConvertorTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2023/12/22.
//

import XCTest
import MorseCode

final class MorseCodeConvertorTests: XCTestCase {
    
    func test_deliverEmptyString_whenNoInput() {
        let sut = makeSUT()
        XCTAssertEqual("", sut.convertToMorseCode(input: ""))
    }
    
    func test_deliverCorrectMorseCode() {
        let sut = makeSUT()
        
        XCTAssertEqual(sosMorseCodeString, sut.convertToMorseCode(input: "SOS"))
        XCTAssertEqual(a123MorseCodeString, sut.convertToMorseCode(input: "a123"))
        XCTAssertEqual(helloWorldMorseCodeString,
                       sut.convertToMorseCode(input: "Hello world!"))
    }
    
    func test_deliverEmptyFlashSignals_whenInputEmptyString() {
        let sut = makeSUT()
        XCTAssertEqual([], sut.convertToMorseFlashSignals(input: ""))
    }
    
    func test_deliverFlashSignals_whenInputMorseCodeString() {
        let sut = makeSUT()
        let sosSignals: [FlashType] = [.di, .pause, .di, .pause, .di, .pause, // S
                                                          .pause, .pause,
                                                          .dah, .pause, .dah, .pause, .dah, .pause, // O
                                                          .pause, .pause,
                                                          .di, .pause, .di, .pause, .di, .pause, // S
                                                          .pause, .pause]
        XCTAssertEqual(sosSignals, sut.convertToMorseFlashSignals(input: sosMorseCodeString))
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> ConvertorStub {
        let sut = ConvertorStub()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private class ConvertorStub: MorseCodeConvertorPrototype { }
    
    private let sosMorseCodeString = "... --- ... "
    private let a123MorseCodeString = ".- .---- ..--- ...-- "
    private let helloWorldMorseCodeString = ".... . .-.. .-.. ---    .-- --- .-. .-.. -.. -.-.-- "
}
