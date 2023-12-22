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
            
            if type == .pause {
                let longPause = [FlashType](repeating: .pause, count: 2)
                signals.append(contentsOf: longPause)
            } else {
                signals.append(type)
                signals.append(.pause) // pause between characters
            }
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
    
    func test_deliverFlashSignals_whenInputMorseCodeString() {
        let sut = makeSUT()
        let sosSignals: [MorseCodeConvertor.FlashType] = [.di, .pause, .di, .pause, .di, .pause, // S
                                                          .pause, .pause,
                                                          .dah, .pause, .dah, .pause, .dah, .pause, // O
                                                          .pause, .pause,
                                                          .di, .pause, .di, .pause, .di, .pause, // S
                                                          .pause, .pause]
        let sosMorseCode = sut.convertToMorseCode(input: "SOS")
        XCTAssertEqual(sosSignals, sut.convertToMorseFlashSignals(input: sosMorseCode))
    }
    
    // MARK: - Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeConvertor {
        let sut = MorseCodeConvertor()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
