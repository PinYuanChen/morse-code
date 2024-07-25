//
// Created on 2023/12/29.
//

import Foundation

public protocol FlashManagerPrototype {
    var currentStatus: FlashStatusType { get }
    func startPlaySignals(signals: [FlashType], uuid: UUID)
    func stopPlayingSignals()
    var didFinishPlaying: (() -> Void)? { get set }
}

public enum FlashStatusType: Equatable {
    case playing(id: UUID)
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
