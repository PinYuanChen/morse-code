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
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("morseRecords.store")
    
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
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("morseRecords.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDownWithError() throws {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("morseRecords.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case .success:
                break
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.success(.none), .success(.none)):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let (_, localRecords) = uniqueRecords()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(localRecords) { insertionResult in
            sut.retrieve { retrieveResult in
                if case let .failure(error) = insertionResult {
                    XCTFail("Unexpected failure with insertion error \(error)")
                }
                
                switch retrieveResult {
                case let .success(retrievedRecords):
                    XCTAssertEqual(retrievedRecords, localRecords)
                    
                default:
                    XCTFail("Expected found result with records\(localRecords), got \(retrieveResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableMorseRecordStore {
        let sut = CodableMorseRecordStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
