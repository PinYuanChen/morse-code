//
// Created on 2023/12/27.
//

import XCTest
import MorseCode

final class FlashManagerTests: XCTestCase {
    
    func test_initDoesNotPlay() {
        let sut = makeSUT()
        XCTAssertEqual(sut.currentStatus, FlashManager.StatusType.stop)
    }
    
    func test_startPlayingEmptySignals_didNotPlay() {
        let sut = makeSUT()
        sut.startPlaySignals(signals: [])
        XCTAssertEqual(sut.currentStatus, FlashManager.StatusType.stop)
    }
    
    func test_startPlayingNonEmptySignals_didPlay() {
        let sut = makeSUT()
        sut.startPlaySignals(signals: [.di])
        XCTAssertEqual(sut.currentStatus, FlashManager.StatusType.playing)
    }
    
    func test_stopPlayingSignals_didStop() {
        let sut = makeSUT()
        sut.startPlaySignals(signals: [.di])
        sut.stopPlayingSignals()
        
        XCTAssertEqual(sut.currentStatus, FlashManager.StatusType.stop)
        XCTAssertEqual(sut.index, 0)
        XCTAssertNil(sut.flashTimer)
    }
    
    // MARK: - Helpers
    private func makeSUT(timerScheduler: TimerSchedulerPrototype = RunLoop.current ,file: StaticString = #file, line: UInt = #line) -> FlashManager {
        let sut = FlashManager(timerScheduler: timerScheduler)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
