//
// Created on 2023/12/25.
//

import XCTest
import MorseCode
import MorseCodeiOS

class ConvertorSpy: MorseCodeConvertorPrototype {
    func convertToMorseCode(input: String) -> String {
        return ""
    }
    
    func convertToMorseFlashSignals(input: String) -> [MorseCode.FlashType] {
        return []
    }
}

final class MorseCodeViewControllerTests: XCTestCase {

    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeViewController {
        let convertor = ConvertorSpy()
        let sut = MorseCodeViewController(convertor: convertor)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
