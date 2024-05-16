//
//  CacheMorseRecordUseCaseTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/16.
//

import XCTest
import MorseCode

class MorseRecordStore {
    var deleteCachedRecordsCallCount = 0
    var insertCallCount = 0
    
    func deleteCachedRecords() {
        deleteCachedRecordsCallCount += 1
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        
    }
}

class LocalMorseRecordLoader {
    
    init(store: MorseRecordStore) {
        self.store = store
    }
    
    func save(_ records: [MorseRecord]) {
        store.deleteCachedRecords()
    }
    
    private let store: MorseRecordStore
}

final class CacheMorseRecordUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedRecordsCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let records = [uniqueRecord(), uniqueRecord()]
        
        sut.save(records)
        
        XCTAssertEqual(store.deleteCachedRecordsCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let records = [uniqueRecord(), uniqueRecord()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(records)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
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
