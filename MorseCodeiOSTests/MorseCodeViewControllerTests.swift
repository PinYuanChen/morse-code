//
// Created on 2023/12/25.
//

import XCTest
import MorseCodeiOS

final class MorseCodeViewControllerTests: XCTestCase {

    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MorseCodeViewController {
        let sut = MorseCodeViewController()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
