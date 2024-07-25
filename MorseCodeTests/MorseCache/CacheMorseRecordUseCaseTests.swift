//
//  CacheMorseRecordUseCaseTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/7/25.
//

import XCTest
import MorseCode

final class CacheMorseRecordUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() async {
        let (sut, store) = makeSUT()
        
        _ = try? await sut.save(uniqueRecords().records)
        
        XCTAssertEqual(store.receivedMessages.first, .deleteCachedRecords)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() async {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        store.completeDeletion(with: deletionError)
        _ = try? await sut.save(uniqueRecords().records)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() async throws {
        let (records, localRecords) = uniqueRecords()
        let (sut, store) = makeSUT()
        
        store.completeDeletionSuccessfully()
        _ = try? await sut.save(records)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRecords, .insert(localRecords)])
    }
    
    func test_save_failsOnDeletionError() async {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        await expect(sut, toCompleteSavingWith: .failure(deletionError), when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() async {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        await expect(sut, toCompleteSavingWith: .failure(insertionError), when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        let (sut, store) = makeSUT()
        
        await expect(sut, toCompleteSavingWith: .success(()), when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalMorseRecordLoader, store: MorseRecordStoreSpy) {
        let store = MorseRecordStoreSpy()
        let sut = LocalMorseRecordLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalMorseRecordLoader, toCompleteSavingWith expectedResult:  Result<Void, Error>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) async {
        
        action()
        
        let receivedResult: Result<Void, Error>!
        
        do {
            try await sut.save([uniqueRecord()])
            receivedResult = .success(())
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (receivedResult, expectedResult) {
        case (.success(_), .success(_)):
            break
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
}
