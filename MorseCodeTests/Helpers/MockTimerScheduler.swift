//
// Created on 2023/12/28.
//

import MorseCode

struct MockTimerScheduler: TimerSchedulerPrototype {
    
    var handleAddTimer: ((_ timer: Timer) -> Void)?
    
    func add(_ timer: Timer, forMode mode: RunLoop.Mode) {
        handleAddTimer?(timer)
    }
}
