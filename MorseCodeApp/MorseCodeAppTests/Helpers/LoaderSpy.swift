//
//  LoaderSpy.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/28.
//

import MorseCode
import MorseCodeApp

final class LoaderSpy: MorseRecordLoaderPrototype {
    
    enum ReceivedMessage {
        case load
        case save
    }
    
    var receivedMessages = [ReceivedMessage]()
    
    func save(_ records: [MorseRecord]) async throws {
        receivedMessages.append(.save)
    }
    
    func load() async throws -> [MorseRecord]? {
        receivedMessages.append(.load)
        return []
    }
}
