//
//  CacheMorseRecordUseCaseTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/16.
//

import XCTest
import MorseCode

final class LocalMorseRecordLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueRecords().records) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniqueRecords().records) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let (records, localRecords) = uniqueRecords()
        let (sut, store) = makeSUT()
        
        sut.save(records) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords, .insert(localRecords)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteSavingWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteSavingWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteSavingWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = MorseRecordStoreSpy()
        var sut: LocalMorseRecordLoader? = LocalMorseRecordLoader(store: store)
        
        var receivedResults = [LocalMorseRecordLoader.SaveResult]()
        sut?.save(uniqueRecords().records) { receivedResults.append($0) }
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = MorseRecordStoreSpy()
        var sut: LocalMorseRecordLoader? = LocalMorseRecordLoader(store: store)
        
        var receivedResults = [LocalMorseRecordLoader.SaveResult]()
        sut?.save(uniqueRecords().records) { receivedResults.append($0) }
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteLoadingWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoRecordOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteLoadingWith: .success(nil), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversRecordsOnNonEmptyCache() {
        let (sut, store) = makeSUT()
        
        let (records, localRecords) = uniqueRecords()
        expect(sut, toCompleteLoadingWith: .success(records), when: {
            store.completeRetrieval(with: localRecords)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnNonEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: uniqueRecords().localRecords)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalMorseRecordLoader, store: MorseRecordStoreSpy) {
        let store = MorseRecordStoreSpy()
        let sut = LocalMorseRecordLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalMorseRecordLoader, toCompleteSavingWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save([uniqueRecord()]) { result in
            switch result {
            case .failure(let error):
                receivedError = error
            default:
                break
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private func expect(_ sut: LocalMorseRecordLoader, toCompleteLoadingWith expectedResult: LocalMorseRecordLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedRecords), .success(expectedRecords)):
                XCTAssertEqual(receivedRecords, expectedRecords, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func uniqueRecords() -> (records: [MorseRecord], localRecords: [LocalMorseRecord]) {
        let records = [uniqueRecord(), uniqueRecord()]
        let localRecords = records.map {
            LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals)
        }
        
        return (records, localRecords)
    }
    
    private func uniqueRecord() -> MorseRecord {
        return .init(id: UUID(), text: "any", morseCode: "any", flashSignals: [])
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
