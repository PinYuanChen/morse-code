//
//  CodableMorseRecordStoreTests.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/20.
//

import XCTest
import MorseCode

class CodableMorseRecordStore {
    func retrieve(completion: @escaping MorseRecordStore.RetrievalCompletion) {
        completion(.success(nil))
    }
}

class CodableMorseRecordStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableMorseRecordStore()
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
}
