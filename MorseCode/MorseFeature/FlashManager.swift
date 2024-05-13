//
// Created on 2023/12/28.
//

import AVFoundation

public class FlashManager: FlashManagerPrototype {
    
    public var currentStatus: FlashStatusType = .stop
    public let timerScheduler: TimerSchedulerPrototype
    public var didFinishPlaying: (() -> Void)?
    public private(set) var index = 0
    
    public init(timerScheduler: TimerSchedulerPrototype = RunLoop.current) {
        self.timerScheduler = timerScheduler
    }
    
    public func getCurrentStatus() -> FlashStatusType {
        currentStatus
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
        index = 0
        didFinishPlaying?()
    }

    private var flashTimer: Timer?
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
            
            index += 1
            scheduleTimer()
        }
        
        guard let timer = flashTimer else { return }
        timerScheduler.add(timer, forMode: .default)
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            print("Torch isn't available")
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }
}
