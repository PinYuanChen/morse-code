//
// Created on 2023/12/28.
//

import AVFoundation

public class FlashManager {
    
    public var currentStatus: StatusType = .stop
    public let timerScheduler: TimerSchedulerPrototype
    public private(set) var flashTimer: Timer?
    public private(set) var index = 0
    
    public init(timerScheduler: TimerSchedulerPrototype) {
        self.timerScheduler = timerScheduler
    }
    
    public enum StatusType {
        case playing
        case pause
        case stop
    }
    
    public func startPlaySignals(signals: [FlashType]) {
        guard !signals.isEmpty else { return }
        
        self.signals = signals
        currentStatus = .playing
        scheduleTimer()
    }
    
    public func stopPlayingSignals() {
        currentStatus = .stop
        toggleTorch(on: false)
        flashTimer?.invalidate()
        flashTimer = nil
    }

    private var signals = [FlashType]()
}

// MARK: - Private functions
private extension FlashManager {
    func scheduleTimer() {
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
    
    func toggleTorch(on: Bool) {
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
