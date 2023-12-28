//
// Created on 2023/12/27.
//

import XCTest
import MorseCode
import AVFoundation

class FlashManager {
    
    var currentStatus: StatusType = .stop
    
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
    
    private func scheduleTimer() {
        // bottom case: turn off timer
        // fetch info by index
        // trigger switch function
        // set timer and call next
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
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FlashManager {
        let sut = FlashManager()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
