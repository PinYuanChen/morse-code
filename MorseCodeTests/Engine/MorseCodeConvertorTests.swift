//
//  MorseCodeConvertorTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2023/12/22.
//

import XCTest

class MorseCodeConvertor {
    func convertToMorseCode(input: String) -> String {
        return ""
    }
}

final class MorseCodeConvertorTests: XCTestCase {
    
    func test_deliverEmptyString_whenNoInput() {
        let sut = makeSUT()
        XCTAssertEqual("", sut.convertToMorseCode(input: ""))
    }
    
    // MARK: - Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeConvertor {
        let sut = MorseCodeConvertor()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
