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
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        try insert(localRecords, to: sut)
        expect(sut, toRetrieve: .success(localRecords))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        try insert(localRecords, to: sut)
        expect(sut, toRetrieveTwice: .success(localRecords))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        _ = try? "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        _ = try? "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() throws {
        let sut = makeSUT()
        
        try insert(uniqueRecords().localRecords, to: sut)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
        let sut = makeSUT()
        try insert(uniqueRecords().localRecords, to: sut)
        
        try insert(uniqueRecords().localRecords, to: sut)
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() throws {
        let sut = makeSUT()
        
        try insert(uniqueRecords().localRecords, to: sut)
        
        let latestRecords = uniqueRecords().localRecords
        try insert(latestRecords, to: sut)
        expect(sut, toRetrieve: .success(latestRecords))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let (_, localRecords) = uniqueRecords()
        
        XCTAssertThrowsError(try insert(localRecords, to: sut))
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() throws {
        let sut = makeSUT()
        
        try deleteCache(from: sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() throws {
        let sut = makeSUT()
        try insert(uniqueRecords().localRecords, to: sut)
        
        try deleteCache(from: sut)
    }
    
    // MARK: - Helpers
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> MorseRecordStore {
        let sut = CodableMorseRecordStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func deleteCache(from sut: MorseRecordStore) throws {
        try sut.deleteCachedRecords()
    }
    
    private func insert(_ records: [LocalMorseRecord], to sut: MorseRecordStore) throws {
        try sut.insert(records)
    }
    
    private func expect(_ sut: MorseRecordStore, toRetrieveTwice expectedResult: Result<[LocalMorseRecord]?, Error>, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: MorseRecordStore, toRetrieve expectedResult: Result<[LocalMorseRecord]?, Error>, file: StaticString = #file, line: UInt = #line) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case (.failure(_), .failure(_)):
            break
            
        case let (.success(expected), .success(retrieved)):
            XCTAssertEqual(retrieved, expected, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
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
