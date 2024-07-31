//
//  MorseUIIntegrationTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/7/31.
//

import XCTest
import MorseCode
import MorseCodeApp

final class MorseCodeViewControllerTests: XCTestCase {
    
    func test_showPlaceholders_whenTextFieldsAreEmpty() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.inputTextField.placeholder, MorseCodePresenter.inputTextPlaceholder)
        XCTAssertEqual(sut.morseTextField.placeholder, MorseCodePresenter.morseCodePlaceholder)
    }
    
    func test_convertButtonIsEnable() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.convertButton.isEnabled)
        
        sut.simulateTypeText(text: "any text")
        XCTAssertTrue(sut.convertButton.isEnabled)
        
        sut.simulateDeleteAllText()
        XCTAssertFalse(sut.convertButton.isEnabled)
    }
    
    func test_convertMorseCode_didDisplayResult() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.morseTextField.text, "")
        
        sut.simulateConvertText(text: anyText)
        XCTAssertEqual(sut.morseTextField.text, anyMorse)
    }
    
    func test_flashButtonIsEnable() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.flashButton.isEnabled)
        
        sut.simulateFlashButton(enable: true)
        XCTAssertTrue(sut.flashButton.isEnabled)
        
        sut.simulateFlashButton(enable: false)
        XCTAssertFalse(sut.flashButton.isEnabled)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeViewController {
        let sut = MorseUIComposer.composeMorseCode(convertor: MorseConvertor(), loader: LoaderSpy(), flashManager: FlashManager())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private let anyText = "any"
    private let anyMorse = ".- -. -.-- "
}
