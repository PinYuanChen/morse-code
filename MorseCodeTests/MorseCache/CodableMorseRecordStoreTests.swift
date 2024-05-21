//
//  CodableMorseRecordStoreTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/20.
//

import XCTest
import MorseCode

class CodableMorseRecordStoreTests: XCTestCase {
    
    override func setUpWithError() throws {
        setupEmptyStoreState()
    }
    
    override func tearDownWithError() throws {
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieveTwice: .success(.none))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        insert(localRecords, to: sut)
        expect(sut, toRetrieve: .success(localRecords))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        insert(localRecords, to: sut)
        expect(sut, toRetrieveTwice: .success(localRecords))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert(uniqueRecords().localRecords, to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let latestRecords = uniqueRecords().localRecords
        let latestInsertionError = insert(latestRecords, to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
        expect(sut, toRetrieve: .success(latestRecords))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let (_, localRecords) = uniqueRecords()
        
        let insertionError = insert(localRecords, to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert(uniqueRecords().localRecords, to: sut)
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueRecords().localRecords) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedRecords { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueRecords().localRecords) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    // MARK: - Helpers
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> MorseRecordStore {
        let sut = CodableMorseRecordStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func deleteCache(from sut: MorseRecordStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedRecords { deletionResult in
            if case let Result.failure(error) = deletionResult {
                deletionError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    @discardableResult
    private func insert(_ records: [LocalMorseRecord], to sut: MorseRecordStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        
        var insertionError: Error?
        sut.insert(records) { insertionResult in
            if case let .failure(error) = insertionResult {
                insertionError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func expect(_ sut: MorseRecordStore, toRetrieveTwice expectedResult: MorseRecordStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: MorseRecordStore, toRetrieve expectedResult: MorseRecordStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.failure(_), .failure(_)):
                break
                
            case let (.success(expected), .success(retrieved)):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
