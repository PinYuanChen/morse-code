//
//  CodableMorseRecordStoreTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/20.
//

import XCTest
import MorseCode

class CodableMorseRecordStore {
    
    private struct CodableMorseRecord: Codable {
        let id: UUID
        let text: String
        let morseCode: String
        let flashSignals: [FlashType]
        
        var local: LocalMorseRecord {
            .init(id: id, text: text, morseCode: morseCode, flashSignals: flashSignals)
        }
    }
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping MorseRecordStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.success(.none))
        }
        
        let decoder = JSONDecoder()
        let records = try! decoder.decode([CodableMorseRecord].self, from: data)
        completion(.success(records.map { LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals) }))
    }
    
    func insert(_ records: [LocalMorseRecord], completion: @escaping MorseRecordStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(records.map { CodableMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals) })
        try! encoded.write(to: storeURL)
        completion(.success(()))
    }
}

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
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(localRecords) { insertionResult in
            if case let .failure(error) = insertionResult {
                XCTFail("Unexpected failure with insertion error \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        expect(sut, toRetrieve: .success(localRecords))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(localRecords) { insertionResult in
            if case let .failure(error) = insertionResult {
                XCTFail("Unexpected failure with insertion error \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieveTwice: .success(localRecords))
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableMorseRecordStore {
        let sut = CodableMorseRecordStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CodableMorseRecordStore, toRetrieveTwice expectedResult: MorseRecordStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CodableMorseRecordStore, toRetrieve expectedResult: MorseRecordStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
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
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
}
