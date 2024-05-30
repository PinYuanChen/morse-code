//
//  LoaderSpy.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/28.
//

import MorseCode
import MorseCodeApp

final class LoaderSpy: MorseRecordLoaderPrototype {
    
    enum ReceivedMessage: Equatable {
        case load
        case save(records: [MorseRecord])
    }
    
    var receivedMessages = [ReceivedMessage]()
    var records = [MorseRecord]()
    
    func save(_ records: [MorseRecord]) async throws {
        receivedMessages.append(.save(records: records))
    }
    
    func load() async throws -> [MorseRecord]? {
        receivedMessages.append(.load)
        return records
    }
    
    func completeLoadingWith(_ records: [MorseRecord]) {
        self.records = records
    }
}
