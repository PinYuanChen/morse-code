//
//  MorseRecordStoreSpy.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/20.
//

import Foundation
import MorseCode

class MorseRecordStoreSpy: MorseRecordStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedRecords
        case insert([LocalMorseRecord])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<[LocalMorseRecord]?, Error>?
    
    func deleteCachedRecords() throws {
        receivedMessages.append(.deleteCachedRecords)
        try deletionResult?.get()
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(())
    }
    
    func insert(_ records: [LocalMorseRecord]) throws {
        receivedMessages.append(.insert(records))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func retrieve() throws -> [LocalMorseRecord]? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with records: [LocalMorseRecord], at index: Int = 0) {
        retrievalResult = .success(records)
    }
}
