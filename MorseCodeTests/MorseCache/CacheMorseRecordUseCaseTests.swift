//
//  CacheMorseRecordUseCaseTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/16.
//

import XCTest
import MorseCode

final class CacheMorseRecordUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let records = [uniqueRecord(), uniqueRecord()]
        
        sut.save(records) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let records = [uniqueRecord(), uniqueRecord()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(records) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let records = [uniqueRecord(), uniqueRecord()]
        let (sut, store) = makeSUT()
        
        sut.save(records) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords, .insert(records)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = MorseRecordStoreSpy()
        var sut: LocalMorseRecordLoader? = LocalMorseRecordLoader(store: store)
        
        var receivedResults = [Error?]()
        sut?.save([uniqueRecord()]) { receivedResults.append($0) }
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = MorseRecordStoreSpy()
        var sut: LocalMorseRecordLoader? = LocalMorseRecordLoader(store: store)
        
        var receivedResults = [Error?]()
        sut?.save([uniqueRecord()]) { receivedResults.append($0) }
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalMorseRecordLoader, store: MorseRecordStoreSpy) {
        let store = MorseRecordStoreSpy()
        let sut = LocalMorseRecordLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class MorseRecordStoreSpy: MorseRecordStore {
        typealias DeletionCompletion = (Error?) -> Void
        typealias InsertionCompletion = (Error?) -> Void
        
        enum ReceivedMessage: Equatable {
            case deleteCachedRecords
            case insert([MorseRecord])
        }
        
        private(set) var receivedMessages = [ReceivedMessage]()
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
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
        
        func insert(_ records: [MorseRecord], completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(records))
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
    
    private func expect(_ sut: LocalMorseRecordLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save([uniqueRecord()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private func uniqueRecord() -> MorseRecord {
        return .init(id: UUID(), text: "any", morseCode: "any", flashSignals: [])
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
