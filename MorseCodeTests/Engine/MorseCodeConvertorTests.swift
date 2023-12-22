//
//  MorseCodeConvertorTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2023/12/22.
//

import XCTest
import MorseCode

class MorseCodeConvertor {
    func convertToMorseCode(input: String) -> String {
        guard !input.isEmpty else {
            return ""
        }
        
        var output = ""
        for char in input.lowercased() {
            guard let mCode = morseCodeDict["\(char)"] else {
                continue
            }
            if mCode == " " {
                output.append("   ")
            } else {
                output.append(mCode)
                output.append(" ")
            }
        }
        
        return output
    }
}

final class MorseCodeConvertorTests: XCTestCase {
    
    func test_deliverEmptyString_whenNoInput() {
        let sut = makeSUT()
        XCTAssertEqual("", sut.convertToMorseCode(input: ""))
    }
    
    func test_deliverCorrectMorseCode() {
        let sut = makeSUT()
        
        XCTAssertEqual("... --- ... ", sut.convertToMorseCode(input: "SOS"))
        XCTAssertEqual(".- .---- ..--- ...-- ", sut.convertToMorseCode(input: "a123"))
        XCTAssertEqual(".... . .-.. .-.. ---    .-- --- .-. .-.. -.. -.-.-- ",
                       sut.convertToMorseCode(input: "Hello world!"))
    }
    
    // MARK: - Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeConvertor {
        let sut = MorseCodeConvertor()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
