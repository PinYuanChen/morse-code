//
// Created on 2023/12/27.
//

import XCTest
import MorseCode

final class FlashManagerTests: XCTestCase {
    
    func test_initDoesNotPlay() {
        let sut = makeSUT()
        XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
    }
    
    func test_startPlayingEmptySignals_didNotPlay() {
        let sut = makeSUT()
        sut.startPlaySignals(signals: [])
        XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
    }
    
    func test_startPlayingNonEmptySignals_didPlay() {
        let sut = makeSUT()
        sut.startPlaySignals(signals: [.di])
        XCTAssertEqual(sut.currentStatus, FlashStatusType.playing)
    }
    
    func test_stopPlayingSignals_didStop() {
        let sut = makeSUT()
        sut.startPlaySignals(signals: [.di])
        sut.stopPlayingSignals()
        
        XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
    }
    
    func test_signalDurations() {
        checkDuration(type: .di, duration: 1)
        checkDuration(type: .dah, duration: 3)
        checkDuration(type: .pause, duration: 1)
    }
    
    // MARK: - Helpers
    private func makeSUT(timerScheduler: TimerSchedulerPrototype = RunLoop.current, file: StaticString = #file, line: UInt = #line) -> FlashManager {
        let sut = FlashManager(timerScheduler: timerScheduler)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func checkDuration(type: FlashType, duration: Double) {
        var timerScheduler = MockTimerScheduler()
        var timerDelay = TimeInterval(0)
        
        timerScheduler.handleAddTimer = { timer in
            timerDelay = timer.fireDate.timeIntervalSinceNow
            timer.fire()
        }
        
        let sut = makeSUT(timerScheduler: timerScheduler)
        sut.startPlaySignals(signals: [type])
        XCTAssertEqual(timerDelay, duration, accuracy: 1)
    }
}