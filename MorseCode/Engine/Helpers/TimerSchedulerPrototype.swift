//
// Created on 2023/12/28.
//

import Foundation

public protocol TimerSchedulerPrototype {
    func add(_ timer: Timer, forMode mode: RunLoop.Mode)
}

extension RunLoop: TimerSchedulerPrototype { }
