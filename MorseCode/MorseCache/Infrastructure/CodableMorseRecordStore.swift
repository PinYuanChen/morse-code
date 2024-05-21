//
//  CodableMorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/21.
//

import Foundation

public class CodableMorseRecordStore: MorseRecordStore {
    
    private struct CodableMorseRecord: Codable {
        let id: UUID
        let text: String
        let morseCode: String
        let flashSignals: [FlashType]
        
        var local: LocalMorseRecord {
            .init(id: id, text: text, morseCode: morseCode, flashSignals: flashSignals)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableMorseRecordStore.self)Queue", qos: .userInitiated)
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.success(.none))
            }
            
            do {
                let decoder = JSONDecoder()
                let records = try decoder.decode([CodableMorseRecord].self, from: data)
                completion(.success(records.map { LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals) }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ records: [LocalMorseRecord], completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async {
            do {
                let encoder = JSONEncoder()
                let codableRecords = records.map { CodableMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals) }
                
                let encoded = try encoder.encode(codableRecords)
                try encoded.write(to: storeURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedRecords(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(.success(()))
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
