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
    
    func test_load_requestsCacheRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        _ = try? await sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() async {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        await expect(sut, toCompleteLoadingWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoRecordOnEmptyCache() async {
        let (sut, store) = makeSUT()
        
        await expect(sut, toCompleteLoadingWith: .success(nil), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversRecordsOnNonEmptyCache() async {
        let (sut, store) = makeSUT()
        
        let (records, localRecords) = uniqueRecords()
        await expect(sut, toCompleteLoadingWith: .success(records), when: {
            store.completeRetrieval(with: localRecords)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() async throws {
        let (sut, store) = makeSUT()
        
        _ = try? await sut.load()
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() async throws {
        let (sut, store) = makeSUT()
        
        _ = try? await sut.load()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnNonEmptyCache() async throws {
        let (sut, store) = makeSUT()
        
        _ = try? await sut.load()
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
    
    private func expect(_ sut: LocalMorseRecordLoader, toCompleteLoadingWith expectedResult: Result<[MorseRecord]?, Error>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) async {
        
        action()
        
        let receivedResult: Result<[MorseRecord]?, Error>!
        do {
            let records = try await sut.load()
            receivedResult = .success(records)
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedRecords), .success(expectedRecords)):
            XCTAssertEqual(receivedRecords, expectedRecords, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
}
