//
// Created on 2023/12/25.
//

import XCTest
import MorseCode
import MorseCodeApp

final class MorseCodeViewControllerTests: XCTestCase {
    
    func test_init_doesNotConvert() {
        let (_, convertor) = makeSUT()
        
        XCTAssertEqual(convertor.convertCallCount, 0)
    }
    
    func test_userInitiatedConvertWithEmptyInput_noConvert() {
        let (sut, convertor) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.simulateConvertInputToMorseCode("")
        
        XCTAssertEqual(convertor.convertCallCount, 0)
    }
    
    func test_userInitiatedConvertFunction_convertInput() {
        let (sut, convertor) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.simulateConvertInputToMorseCode("test")
        XCTAssertEqual(convertor.convertCallCount, 1)
        sut.simulateConvertInputToMorseCode("test2")
        XCTAssertEqual(convertor.convertCallCount, 2)
    }
    
    func test_userInitiatedConvertFunction_overrideFormerInput() {
        let (sut, convertor) = makeSUT()
        sut.loadViewIfNeeded()
        
        let firstInput = "First input"
        sut.simulateConvertInputToMorseCode(firstInput)
        XCTAssertEqual(convertor.morseCodeString, firstInput)
        
        let secondInput = "Second input"
        sut.simulateConvertInputToMorseCode(secondInput)
        XCTAssertEqual(convertor.morseCodeString, secondInput)
    }
    
    func test_userInitiatedFlashWithEmptyInput_noFlash() {
        let (sut, convertor) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInvokeFlash()
        XCTAssertEqual(convertor.flashCallCount, 0)
        
        sut.simulateConvertInputToMorseCode("")
        sut.simulateInvokeFlash()
        XCTAssertEqual(convertor.flashCallCount, 0)
    }
    
    func test_userInitiatedFlashWithValidInput_showsFlash() {
        let (sut, convertor) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateConvertInputToMorseCode("input")
        sut.simulateInvokeFlash()
        XCTAssertEqual(convertor.flashCallCount, 1)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: MorseCodeViewController, convertor: ConvertorSpy) {
        let convertor = ConvertorSpy()
        let sut = MorseCodeViewController(convertor: convertor)
        trackForMemoryLeaks(convertor, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, convertor)
    }
}

extension MorseCodeViewController {
    func simulateConvertInputToMorseCode(_ input: String) {
        currentInputText = input
        convertButton.simulateTap()
    }
    
    func simulateInvokeFlash() {
        flashButton.simulateTap()
    }
}
