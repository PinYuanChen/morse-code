//
//  FlashManager+TestHelpers.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/8/1.
//

import MorseCode
import MorseCodeApp

class ViewSpy: MorseCodePresenterDelegate, RecordsPresenterDelegate {
    
    enum ReceivedMessage: Equatable {
        case error(title: String?, message: String)
        case updateButton(status: MorseCode.FlashStatusType, enable: Bool)
        case reloadData
    }
    
    var receivedMessages = [ReceivedMessage]()
    
    func showError(title: String?, message: String) {
        receivedMessages.append(.error(title: title, message: message))
    }
    
    func updateFlashButton(status: MorseCode.FlashStatusType, enable: Bool) {
        receivedMessages.append(.updateButton(status: status, enable: enable))
    }
    
    func reloadData() {
        receivedMessages.append(.reloadData)
    }
}
