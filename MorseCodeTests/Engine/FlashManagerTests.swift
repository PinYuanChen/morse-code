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
        sut.didFinishPlaying = { [weak sut] in
            guard let sut = sut else { return }
            XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
        }
        
        sut.startPlaySignals(signals: [.di])
        sut.stopPlayingSignals()
    }
    
    func test_signalDurations() {
        let signals: [FlashType] = [.di, .pause, .pause, .dah, .pause, .dah, .pause]
        
        signals.forEach {
            checkDuration(type: $0, duration: $0.duration)
        }
    }
    
    func test_finishPlaySignals_didResetIndex() {
        var timerScheduler = MockTimerScheduler()
        timerScheduler.handleAddTimer = { timer in
            timer.fire()
        }
        
        let sut = makeSUT(timerScheduler: timerScheduler)
        
        let exp = expectation(description: "Wait for stop")
        sut.didFinishPlaying = { [weak sut] in
            guard let sut = sut else { return }
            XCTAssertEqual(sut.index, 0)
            exp.fulfill()
        }
        
        sut.startPlaySignals(signals: [.di])
        wait(for: [exp], timeout: 1)
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
