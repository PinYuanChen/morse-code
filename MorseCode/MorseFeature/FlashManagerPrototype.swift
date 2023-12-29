//
// Created on 2023/12/29.
//

import Foundation

public protocol FlashManagerPrototype {
    func getCurrentStatus() -> FlashStatusType
    func startPlaySignals(signals: [FlashType])
    func stopPlayingSignals()
    var didFinishPlaying: (() -> Void)? { get set }
}

public enum FlashStatusType {
    case playing
    case pause
    case stop
}

public enum FlashType: String {
    case dah = "-"
    case di = "."
    case pause = " "
    
    public var turnOn: Bool {
        return self != .pause
    }
    
    public var duration: Double {
        switch self {
        case .dah:
            return 3.0
        case .di, .pause:
            return 1.0
        }
    }
}
