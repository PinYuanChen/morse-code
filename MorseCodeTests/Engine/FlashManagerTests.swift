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
    
    func startPlaySignals() {
        currentStatus = .playing
    }
    
    private func swtichTorch(on: Bool) {
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
