//
//  MorseUIIntegrationTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/7/31.
//

import XCTest
import MorseCode
import MorseCodeApp

final class MorseUIIntegrationTests: XCTestCase {
    
    func test_convertButtonStatus() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.convertButton.isEnabled)
        
        sut.simulateTypeText(text: "any text")
        XCTAssertTrue(sut.convertButton.isEnabled)
        
        sut.simulateDeleteAllText()
        XCTAssertFalse(sut.convertButton.isEnabled)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: MorseCodeViewController, loader: LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = MorseUIComposer.composeMorseCode(convertor: MorseConvertor(), loader: loaderSpy, flashManager: FlashManager())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        return (sut, loaderSpy)
    }
}
