//
// Created on 2023/12/25.
//

import XCTest
import MorseCode
import MorseCodeiOS

final class ConvertorSpy: MorseCodeConvertorPrototype {
    
    var convertCallCount = 0
    
    func convertToMorseCode(input: String) -> String {
        convertCallCount += 1
        return ""
    }
    
    func convertToMorseFlashSignals(input: String) -> [MorseCode.FlashType] {
        return []
    }
}

final class MorseCodeViewControllerTests: XCTestCase {
    
    func test_init_doesNotConvert() {
        let (_, convertor) = makeSUT()
        
        XCTAssertEqual(convertor.convertCallCount, 0)
    }
    
    func test_userInitiatedConvertFunction_convertInput() {
        let (sut, convertor) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.convertButton.simulateTap()
        
        XCTAssertEqual(convertor.convertCallCount, 1)
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
