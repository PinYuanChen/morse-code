//
// Created on 2023/12/29.
//

import Foundation

public protocol FlashManagerPrototype {
    var currentStatus: FlashStatusType { get }
    func startPlaySignals(signals: [FlashType])
    func stopPlayingSignals()
    var didFinishPlaying: (() -> Void)? { get set }
}

public enum FlashStatusType {
    case playing
    case pause
    case stop
    
    public var imageName: String {
        switch self {
        case .playing:
            return "flashlight.slash.circle.fill"
        default:
            return "flashlight.on.circle.fill"
        }
    }
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
