//
// Created on 2023/12/22.
//

import Foundation

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
