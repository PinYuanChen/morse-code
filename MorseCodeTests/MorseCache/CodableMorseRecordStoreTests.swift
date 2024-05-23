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
    
    func test_retrieve_deliversEmptyOnEmptyCache() async {
        let sut = makeSUT()
        await expect(sut, toRetrieve: .success(.none))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        let sut = makeSUT()
        await expect(sut, toRetrieveTwice: .success(.none))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() async throws {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        try await insert(localRecords, to: sut)
        await expect(sut, toRetrieve: .success(localRecords))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        try await insert(localRecords, to: sut)
        await expect(sut, toRetrieveTwice: .success(localRecords))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() async {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        _ = try? "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        await expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() async {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        _ = try? "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        await expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()
        
        try await insert(uniqueRecords().localRecords, to: sut)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()
        try await  insert(uniqueRecords().localRecords, to: sut)
        
        try await insert(uniqueRecords().localRecords, to: sut)
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() async throws {
        let sut = makeSUT()
        
        try await  insert(uniqueRecords().localRecords, to: sut)
        
        let latestRecords = uniqueRecords().localRecords
        try await insert(latestRecords, to: sut)
        await expect(sut, toRetrieve: .success(latestRecords))
    }
    
    func test_insert_deliversErrorOnInsertionError() async {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let (_, localRecords) = uniqueRecords()
        
        do {
            try await insert(localRecords, to: sut)
            XCTFail("Expected insertion error error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()
        
        try await deleteCache(from: sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() async throws {
        let sut = makeSUT()
        try await insert(uniqueRecords().localRecords, to: sut)
        
        try await deleteCache(from: sut)
    }
    
    // MARK: - Helpers
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> MorseRecordStore {
        let sut = CodableMorseRecordStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func deleteCache(from sut: MorseRecordStore) async throws {
        try await sut.deleteCachedRecords()
    }
    
    private func insert(_ records: [LocalMorseRecord], to sut: MorseRecordStore) async throws {
        try await sut.insert(records)
    }
    
    private func expect(_ sut: MorseRecordStore, toRetrieveTwice expectedResult: Result<[LocalMorseRecord]?, Error>, file: StaticString = #file, line: UInt = #line) async {
        await expect(sut, toRetrieve: expectedResult, file: file, line: line)
        await expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: MorseRecordStore, toRetrieve expectedResult: Result<[LocalMorseRecord]?, Error>, file: StaticString = #file, line: UInt = #line) async {
        
        let retrievedResult: Result<[LocalMorseRecord]?, Error>!
        do {
            let records = try await sut.retrieve()
            retrievedResult = .success(records)
        } catch {
            retrievedResult = .failure(error)
        }
        
        switch (expectedResult, retrievedResult) {
        case (.failure(_), .failure(_)):
            break
            
        case let (.success(expected), .success(retrieved)):
            XCTAssertEqual(retrieved, expected, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(String(describing: retrievedResult)) instead", file: file, line: line)
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
