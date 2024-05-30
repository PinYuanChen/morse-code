//
//  RecordsPresenterTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/30.
//

import XCTest
import MorseCode
import MorseCodeApp

class RecordsPresenter {
    var records = [MorseRecord]()
}

final class RecordsPresenterTests: XCTestCase {
    func test_initDoesNotLoadRecords() {
        let sut = makeSUT()
        XCTAssertEqual(sut.records, [])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RecordsPresenter {
        
        let sut = RecordsPresenter()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
