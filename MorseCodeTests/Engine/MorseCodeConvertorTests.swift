//
//  MorseCodeConvertorTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2023/12/22.
//

import XCTest
import MorseCode

class MorseCodeConvertor {
    
    enum FlashType: String {
        case dah = "-"
        case di = "."
        case pause = " "
        
        var duration: Double {
            switch self {
            case .dah:
                return 3.0
            case .di, .pause:
                return 1.0
            }
        }
    }
    
    func convertToMorseCode(input: String) -> String {
        
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
    
    func convertToMorseFlashSignals(input: String) -> [FlashType] {
        
        var signals = [FlashType]()
        for char in input {
            guard let type = FlashType(rawValue: "\(char)") else { continue }
            
            signals.append(type)
        }
        
        return signals
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
    
    func test_deliverEmptyFlashSignals_whenInputEmptyString() {
        let sut = makeSUT()
        XCTAssertEqual([], sut.convertToMorseFlashSignals(input: ""))
    }
    
    // MARK: - Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeConvertor {
        let sut = MorseCodeConvertor()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}