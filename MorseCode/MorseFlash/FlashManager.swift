//
// Created on 2023/12/28.
//

import AVFoundation

public class FlashManager: FlashManagerPrototype {
    
    public private(set) var currentStatus: FlashStatusType = .stop
    public let timerScheduler: TimerSchedulerPrototype
    public var didFinishPlaying: (() -> Void)?
    public private(set) var index = 0
    
    public init(timerScheduler: TimerSchedulerPrototype = RunLoop.current) {
        self.timerScheduler = timerScheduler
    }
    
    public static func enableTorch() -> Bool {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            return false
        }
        return true
    }
    
    public func startPlaySignals(signals: [FlashType], uuid: UUID = .init()) {
        guard !signals.isEmpty else { return }
        
        self.signals = signals
        currentStatus = .playing(id: uuid)
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
    
    deinit {
        toggleTorch(on: false)
        flashTimer?.invalidate()
        flashTimer = nil
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
        
        flashTimer = Timer.scheduledTimer(withTimeInterval: flashType.duration, repeats: false) { [unowned self] timer in
            self.index += 1
            self.scheduleTimer()
        }
        
        guard let timer = flashTimer else { return }
        timerScheduler.add(timer, forMode: .default)
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
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
