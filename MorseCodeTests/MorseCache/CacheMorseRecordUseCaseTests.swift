//
//  CacheMorseRecordUseCaseTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/16.
//

import XCTest
import MorseCode

class MorseRecordStore {
    typealias DeletionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCachedRecords
        case insert([MorseRecord])
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedRecords(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedRecords)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ records: [MorseRecord]) {
        receivedMessages.append(.insert(records))
    }
}

class LocalMorseRecordLoader {
    
    init(store: MorseRecordStore) {
        self.store = store
    }
    
    func save(_ records: [MorseRecord]) {
        store.deleteCachedRecords { [unowned self] error in
            if error == nil {
                self.store.insert(records)
            }
        }
    }
    
    private let store: MorseRecordStore
}

final class CacheMorseRecordUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let records = [uniqueRecord(), uniqueRecord()]
        
        sut.save(records)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let records = [uniqueRecord(), uniqueRecord()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(records)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let records = [uniqueRecord(), uniqueRecord()]
        let (sut, store) = makeSUT()
        
        sut.save(records)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords, .insert(records)])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalMorseRecordLoader, store: MorseRecordStore) {
        let store = MorseRecordStore()
        let sut = LocalMorseRecordLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueRecord() -> MorseRecord {
        return .init(id: UUID(), text: "any", morseCode: "any", flashSignals: [])
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
