//
//  CacheMorseRecordUseCaseTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/16.
//

import XCTest

class MorseRecordStore {
    var deleteCachedRecordsCallCount = 0
}

class LocalMorseRecordLoader {
    
    init(store: MorseRecordStore) {
        self.store = store
    }
    
    private let store: MorseRecordStore
}

final class CacheMorseRecordUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedRecordsCallCount, 0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalMorseRecordLoader, store: MorseRecordStore) {
        let store = MorseRecordStore()
        let sut = LocalMorseRecordLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
