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
    
    func test_convertInputTextToMorseCode() {
        let (sut, convertor) = makeSUT()
        
        let _ = sut.convertToMorseCode(text: "test1")
        XCTAssertEqual(convertor.convertCallCount, 1)
        let _ = sut.convertToMorseCode(text: "test2")
        XCTAssertEqual(convertor.convertCallCount, 2)
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
