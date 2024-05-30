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
    
    func test_doesNotPlay_onInvalidDevice() {
        let sut = makeSUT()
        playSignals(sut, signals: [.di], enableTorch: false)
        XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
    }
    
    func test_validDevice_startPlayingEmptySignals_didNotPlay() {
        let sut = makeSUT()
        playSignals(sut, signals: [])
        XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
    }
    
    func test_validDevice_startPlayingNonEmptySignals_didPlay() {
        let sut = makeSUT()
        playSignals(sut, signals: [.di])
        XCTAssertEqual(sut.currentStatus, FlashStatusType.playing)
    }
    
    func test_validDevice_stopPlayingSignals_didStop() {
        let sut = makeSUT()
        sut.didFinishPlaying = { [weak sut] in
            guard let sut = sut else { return }
            XCTAssertEqual(sut.currentStatus, FlashStatusType.stop)
        }
        
        playSignals(sut, signals: [.dah])
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
        
        playSignals(sut, signals: [.di])
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helpers
    private func makeSUT(timerScheduler: TimerSchedulerPrototype = RunLoop.current, file: StaticString = #file, line: UInt = #line) -> FlashManager {
        let sut = FlashManager(timerScheduler: timerScheduler)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func playSignals(_ sut: FlashManager, signals: [FlashType], enableTorch: Bool = true) {
        sut.startPlaySignals(signals: signals, torchEnable: { return enableTorch })
    }
    
    private func checkDuration(type: FlashType, duration: Double) {
        var timerScheduler = MockTimerScheduler()
        var timerDelay = TimeInterval(0)
        
        timerScheduler.handleAddTimer = { timer in
            timerDelay = timer.fireDate.timeIntervalSinceNow
            timer.fire()
        }
        
        let sut = makeSUT(timerScheduler: timerScheduler)
        playSignals(sut, signals: [type])
        XCTAssertEqual(timerDelay, duration, accuracy: 1)
    }
}
