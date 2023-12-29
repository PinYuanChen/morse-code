//
// Created on 2023/12/29.
//

import Foundation

public protocol FlashManagerPrototype {
    func getCurrentStatus() -> FlashStatusType
    func startPlaySignals(signals: [FlashType])
    func stopPlayingSignals()
}

public enum FlashStatusType {
    case playing
    case pause
    case stop
}
