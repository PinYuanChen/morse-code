//
// Created on 2023/12/27.
//

import XCTest
import MorseCode

class FlashManager {
    
    var currentStatus: StatusType = .stop
    
    enum StatusType {
        case playing
        case pause
        case stop
    }
    
    func startPlaySignals() {
        currentStatus = .playing
    }
}

final class FlashManagerTests: XCTestCase {
    
    func test_initDoesNotPlay() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.currentStatus, FlashManager.StatusType.stop)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FlashManager {
        let sut = FlashManager()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
