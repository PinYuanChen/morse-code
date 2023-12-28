//
// Created on 2023/12/27.
//

import XCTest
import MorseCode
import AVFoundation

class FlashManager {
    
    var currentStatus: StatusType = .stop
    let timerScheduler: TimerSchedulerPrototype
    
    init(timerScheduler: TimerSchedulerPrototype) {
        self.timerScheduler = timerScheduler
    }
    
    enum StatusType {
        case playing
        case pause
        case stop
    }
    
    func startPlaySignals(signals: [FlashType]) {
        guard !signals.isEmpty else { return }
        
        self.signals = signals
        currentStatus = .playing
        scheduleTimer()
    }
    
    func stopPlayingSignals() {
        currentStatus = .stop
        toggleTorch(on: false)
        flashTimer?.invalidate()
        flashTimer = nil
    }
    
    private func scheduleTimer() {
        guard index < signals.count else {
            stopPlayingSignals()
            return
        }
        
        let flashType = signals[index]
        toggleTorch(on: flashType.turnOn)
        
        flashTimer = Timer.scheduledTimer(withTimeInterval: flashType.duration, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            
            self.index += 1
            self.scheduleTimer()
        }
        
        guard let timer = flashTimer else { return }
        timerScheduler.add(timer, forMode: .default)
    }
    
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else {
            print("Torch isn't available")
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            
            if on {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel.significand)
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }

    private(set) var flashTimer: Timer?
    private(set) var index = 0
    private var signals = [FlashType]()
}

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
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FlashManager {
        let sut = FlashManager(timerScheduler: RunLoop.current)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
