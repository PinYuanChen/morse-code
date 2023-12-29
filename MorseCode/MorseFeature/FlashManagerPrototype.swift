//
// Created on 2023/12/29.
//

import Foundation

protocol FlashManagerPrototype {
    func getCurrentStatus() -> FlashStatusType
}

public enum FlashStatusType {
    case playing
    case pause
    case stop
}
